# ☸️ Kubernetes Development Guide (kind)

This guide explains how to run the backend and PostgreSQL HA group locally with `kind` (Kubernetes IN Docker)

---

## 1. Prerequisites
Ensure you have the following tools installed:
* **Docker**: To build images and run the cluster nodes.
* **kind**: To create the local Kubernetes cluster.
* **kubectl**: To interact with the cluster.

---

## 2. Infrastructure Setup

**The steps below can be done automatically with the script `infrastructure/k8s/dev/setup.sh`**
You just need to have the secrets file (see a template below). Then run:

```Bash
cd infrastructure/k8s/dev
chmod +x setup.sh
./setup.sh <secrets-file-path>
```

After that, you can forward ports to access the API and DB or just use the NodePort service.

---
---

### Define Secrets

- Create a file at `infrastructure/k8s/dev/secrets.yml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: fivejars-secrets
  namespace: fivejars
type: Opaque
stringData:
  # CNPG looks for 'password' and 'username' by default
  username: "<fivejars_db_user>" 
  password: "<your_password>"

  DB_URL: "jdbc:postgresql://fivejars-db-rw:5432/five_jars_db"
  DB_NAME: "five_jars_db"
  DB_USERNAME: "fivejars_db_user"
  DB_PASSWORD: "<your_password>"
  # IMPORTANT: This chooses the active Spring profile
  SPRING_PROFILES_ACTIVE: "dev" # or "prod"
  LOAD_SEEDS: "true" # "false" for prod
  JWT_SECRET_KEY: "<your_jwt_secret_key>"
  JWT_EXPIRATION: "<jwt_expiration_in_ms>"
```

### Create the Cluster
If you haven't created the cluster yet, run:
```bash
kind create cluster --name <cluster-name> --config infrastructure/k8s/dev/kind-config.yml
```

> The steps below are intended for one cluster, but can be repeated for multiple clusters if needed.
To apply cluster configs/secrets or to load images, specify the cluster context:
```Bash
kubectl config use-context kind-<cluster-name>`
```
> To target a specific cluster, you can also use the `--context` flag with kubectl commands. For example:
```Bash
kubectl --context kind-<cluster-name> apply -f infrastructure/k8s/dev/secrets.yml
```

---

## 3. The Build & Load Pipeline

Since kind does not use your local Docker registry directly, you must manually "push" images into the cluster nodes.

### Step 1: Build the Image

From the project root:
```Bash
docker build -t five-jars-backend:v0.0.2 -f  backend/spring_api/Dockerfile .
```
>`v0.0.2` can be replaced by any tag, just make sure it matches the image name in `infrastructure/k8s/dev/springboot.yml`. It should be the app release version though.

### Step 2: Load into Kind

```Bash
kind load docker-image fivejars-backend:v0.0.2 --name <cluster-name>
```

## 4. Deployment

Deploy the components in order. The database must be ready before the backend attempts Flyway migrations.

```bash
# Apply the namespace and secrets object to the cluster:
kubectl apply -f infrastructure/k8s/dev/namespace.yml
kubectl apply -f infrastructure/k8s/dev/secrets.yml -n fivejars

# Apply the CNPG operator
kubectl apply -f infrastructure/k8s/dev/cnpg-1.28.1.yaml --server-side

# Apply the metrics server
kubectl apply -f infrastructure/k8s/dev/metrics-server.yaml

# Deploy Postgres HA group:
kubectl apply -f infrastructure/k8s/dev/postgres-hag.yml -n fivejars

# Apply network policies:
kubectl apply -f infrastructure/k8s/dev/network-policy.yml -n fivejars

# Deploy Backend and the HPA:
kubectl apply -f infrastructure/k8s/dev/springboot.yml
kubectl apply -f infrastructure/k8s/dev/springboot-hpa.yml
```

## 5. Connecting from Host

By default, the backend is exposed via a NodePort service on port `30080` and you can directly access it at `http://localhost:30080`. However, for more direct access to the API and DB, you can use `kubectl port-forward`:

To access the API or Database from your machine:
<table>
    <tr>
        <th>Target</th>
        <th>Command</th>
        <th>Access URL</th>
    </tr>
    <tr>
        <td>Spring API</td>
        <td><code>kubectl port-forward svc/backend-service 8080:8080</code></td>
        <td>http://localhost:8080</td>
    </tr>
    <tr>
        <td>Postgres</td>
        <td><code>kubectl port-forward svc/postgres-service 5432:5432</code></td>
        <td>localhost:5432</td>
    </tr>
</table>

## 6. Debugging & Maintenance
- Check Health
```Bash
# See all resources
kubectl get all

# See pod status (Check for CrashLoopBackOff)
kubectl get pods
```

- Inspect Logs

```Bash
# If the backend fails to start (Flyway errors or Connection issues):

kubectl logs -f deployment/backend-deployment
```

- Restart after code Changes

```Bash
# After rebuilding and re-loading a new image into kind, force the pods to recreate:

kubectl rollout restart deployment backend-deployment
```

- Database Access (Direct)

```Bash
# To run SQL queries directly inside the cluster:

kubectl exec -it postgres-0 -- psql -U <user> -d five_jars_db
```

- Delete Cluster
```Bash
kind delete cluster --name <cluster-name>
```

### ⚠️ Common Troubleshooting
- ErrImageNeverPull
    - Cause: Kubernetes can't find the image in the internal kind node cache.
    - Fix: Ensure the image: name in springboot.yml matches the docker tag exactly (e.g., fivejars-backend:dev) and that imagePullPolicy is set to Never.

- Connection Refused (localhost:5432)
    - Cause: The backend is trying to find the DB inside its own container.
    - Fix: Update the DB_URL in your deployment YAML to use the service DNS: jdbc:postgresql://postgres-service:5432/five_jars_db.

- Relation "X" does not exist (Flyway)
    - Cause: A Repeatable migration (R__) is running before the table is created by a Versioned migration (V__), or a previous migration failed.
    - Fix: Check migration order and ensure names match

- Flyway error `SQL state 28P01`:
    - Ensure `username == DB_USERNAME` and `password == DB_PASSWORD` in secrets.
    - Ensure `DB_URL` uses `fivejars-db-rw`.

- Health probes return `403`:
    - Ensure actuator endpoints are allowed by Spring Security and are set up correctly in `application.yml`.

- NodePort requests hang:
    - Check ingress rules in `infrastructure/k8s/dev/network-policy.yml`.