#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <secrets-file-path>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERSION="0.0.2"
NAMESPACE="fivejars"
CLUSTER_NAME="fivejars-cluster"
SECRETS_PATH="$1"
IMAGE_NAME="fivejars-backend:v$VERSION"

if [ ! -f "$SECRETS_PATH" ]; then
  echo "Error: Secrets file not found at $SECRETS_PATH"
  exit 1
fi

echo "--- 🛠️ Building/Verifying Docker Image Version $VERSION ---"

if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  docker build -t $IMAGE_NAME -f $SCRIPT_DIR/../../../backend/spring_api/Dockerfile $SCRIPT_DIR/../../../
fi

echo "--- ☸️ Creating Cluster: $CLUSTER_NAME ---"
# Check if the cluster already exists before trying to delete it
if kind get clusters | grep -q "$CLUSTER_NAME"; then
  read -p "Delete existing cluster? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    kind delete cluster --name "$CLUSTER_NAME"
  fi
  else
    exit 0
  fi
fi

kind create cluster --name "$CLUSTER_NAME" --config $SCRIPT_DIR/kind-config.yml

echo "--- 📦 Loading Backend Image into Cluster ---"
kind load docker-image "$IMAGE_NAME" --name "$CLUSTER_NAME"

# 1. Namespace and Secrets
echo "--- ☸️ Deploying to Namespace: $NAMESPACE ---"
kubectl apply -f $SCRIPT_DIR/namespace.yml

echo "--- 🔐 Applying Secrets ---"
kubectl apply -f "$SECRETS_PATH" -n "$NAMESPACE"

# 2. CNPG Operator
echo "--- 🤖 Installing CloudNativePG Operator ---"
kubectl apply -f $SCRIPT_DIR/cnpg-1.28.1.yaml --server-side
echo "Waiting for Operator to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/cnpg-controller-manager -n cnpg-system

# 3. Metrics Server (for HPA)
echo "--- 📈 Installing Metrics Server ---"
kubectl apply -f $SCRIPT_DIR/metrics-server.yaml

# Patch metrics server for 'kind' self-signed certs. Unsafe for production
# kubectl patch deployment metrics-server -n kube-system --type='json' \
# 	-p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

echo "--- 💾 Starting Database High Availability Group and applying Network Policies ---"

# DOUBLE CHECK: Ensure the secret actually has the required keys for CNPG
REQUIRED_KEYS=("username" "password")
for key in "${REQUIRED_KEYS[@]}"; do
  if ! kubectl get secret fivejars-secrets -o jsonpath="{.data.$key}" -n "$NAMESPACE" &> /dev/null; then
    echo "❌ ERROR: Secret 'fivejars-secrets' is missing the '$key' key!"
    exit 1
  fi
done

# 4. Database group + Network Policies
kubectl apply -f $SCRIPT_DIR/postgres-hag.yml -n "$NAMESPACE"
kubectl apply -f $SCRIPT_DIR/network-policy.yml -n "$NAMESPACE"

echo "Waiting for the Operator to initialize the Pods..."
# Loop until the pod actually exists in the API server
until kubectl get pod fivejars-db-1 -n "$NAMESPACE" &> /dev/null; do
  echo "  ... waiting for pod 'fivejars-db-1' to be created ..."
  sleep 4
done

echo "Waiting for Primary Database node to be healthy..."
# This waits for the first DB pod to reach 'Ready' status
kubectl wait --for=condition=Ready --timeout=120s pod/fivejars-db-1 -n "$NAMESPACE"

# 5. Backend Deployment + HPA
echo "--- 🚀 Launching Backend & Auto-scaler ---"
kubectl apply -f $SCRIPT_DIR/springboot.yml -n "$NAMESPACE"
kubectl apply -f $SCRIPT_DIR/springboot-hpa.yml -n "$NAMESPACE"

echo "--- ✅ Infrastructure is ONLINE ---"
echo "Run 'kubectl get pods' to see the status."

