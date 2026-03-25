# Five Jars Ultra

Money management app based on the five jars method.

## Tech Stack

- Frontend: Flutter. A cross-platform UI framework in Dart that allows to build beautiful and responsive apps for mobile, web, and desktop from a single codebase
- Backend API: Spring Boot, the Holy Grail. A mature Java framework that simplifies building production-ready applications with a vast ecosystem of libraries.
- Database: PostgreSQL. A powerful open-source relational database known for its reliability and feature set.
- COBOL microservice. This is the star of the show. A microservice written in COBOL, running on OpenCobol, and containerized with Docker. I just wanted to prove that it's possible to integrate legacy technologies into modern architectures.


## Project Structure

```text
.
├── backend
│   ├── cobol_microservice
│   └── spring_api
├── flutter_frontend
└── infrastructure
		├── db
		└── k8s
```

## Setup Options

### Option A: Kubernetes Dev Environment (recommended)

Follow [infrastructure/k8s/README.md](./infrastructure/k8s/README.md).

Quick start:

```bash
cd infrastructure/k8s/dev
./setup.sh ./.secrets.yml
```

This starts:
- Namespace `fivejars`
- CloudNativePG Postgres cluster
- Backend deployment, service, and HPA
- Network policies and metrics-server

### Option B: Manually deploy each component of the tech stack

#### The Database
Follow [infrastructure/db/README.md](./infrastructure/db/README.md) to start the database, reachable at `localhost:5432` after running the container

Quick start:

```bash
cd infrastructure/db
docker compose up -d
```

#### The Backend API

Ensure PostgreSQL is running, then run from `backend/spring_api`:

```bash
./gradlew bootRun
```

> Note: the runner needs the environment to have some variables defined to connect with the database and choose an active profile. A `.env` file is recommended to be had in the root of the project with the following content:

```env
DB_URL=jdbc:postgresql://localhost:5432/five_jars_db
POSTGRES_DB=five_jars_db
POSTGRES_USER=fivejars_db_user
POSTGRES_PASSWORD=<your_password>
LOAD_SEEDS=true/false
JWT_SECRET_KEY=<your_jwt_secret_key>
JWT_EXPIRATION=<jwt_expiration_in_ms>
```

## Environment Notes

There are two secret configs in this project:

- Root `.env` file:
	- Mainly for standalone/local workflows.
- Kubernetes Secret file:
	- Used by k8s deployment.
	- Expected keys include `username`, `password`, `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `JWT_SECRET_KEY`, and `JWT_EXPIRATION`.
    - More on that at [infrastructure/k8s/README.md](./infrastructure/k8s/README.md#define-secrets).

Do not commit real secrets :)

## Useful Commands

Kubernetes status:

```bash
kubectl get pods -n fivejars
kubectl get svc -n fivejars
kubectl get hpa -n fivejars
```

Backend health through NodePort:

```bash
curl http://localhost:30080/actuator/health
```