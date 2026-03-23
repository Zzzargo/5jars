# ☸️ Kubernetes Development Guide (kind)

This guide provides the necessary steps to build, deploy, and manage the **Five Jars Ultra** backend and database within a local `kind` (Kubernetes IN Docker) cluster.

---

## 1. Prerequisites
Ensure you have the following tools installed:
* **Docker**: To build images and run the cluster nodes.
* **kind**: To create the local Kubernetes cluster.
* **kubectl**: To interact with the cluster.

---

## 2. Infrastructure Setup

### Define Secrets

- Create a file at `infrastructure/k8s/dev/secrets.yml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: fivejars-secrets
type: Opaque # The default
stringData:
  DB_URL: "jdbc:postgresql://postgres-service:5432/five_jars_db"
  POSTGRES_DB: "five_jars_db"
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "your_password"
  # IMPORTANT: This chooses the active Spring profile
  SPRING_PROFILES_ACTIVE: "dev" # or "prod"
  LOAD_SEEDS: "true" # "false" for prod
  JWT_SECRET_KEY: "your supersecretkey"
  JWT_EXPIRATION: "1100000" # in milliseconds, adjust as needed
```

### Create the Cluster
If you haven't created the cluster yet, run:
```bash
kind create cluster --name <cluster-name>
```

Apply the secrets object to the cluster:
```bash
kubectl apply -f infrastructure/k8s/dev/secrets.yml
```
---

## 3. The Build & Load Pipeline

Since kind does not use your local Docker registry directly, you must manually "push" images into the cluster nodes.

### Step 1: Build the Image

From the project root:
```Bash
docker build -t fivejars-backend:v1 -f  backend/spring_api/Dockerfile .
```
>`v1` can be replaced by any tag, just make sure it matches the image name in `infrastructure/k8s/dev/springboot.yml`.

### Step 2: Load into Kind

```Bash
kind load docker-image fivejars-backend:v1 --name <cluster-name>
```

## 4. Deployment

Deploy the components in order. The database must be ready before the backend attempts Flyway migrations.
```Bash
    # Deploy Postgres:
    kubectl apply -f infrastructure/k8s/dev/postgres.yml

    # Deploy Backend:
    kubectl apply -f infrastructure/k8s/dev/springboot.yml
```

## 5. Connecting from Host (Port Forwarding)

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
