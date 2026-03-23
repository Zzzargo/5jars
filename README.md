## Installing
- The project expects you to have a .env file in the root, where this README lays, with the secrets inside. Defaults are
provided but may not work


# Five Jars Ultra
**The superior money management app based on the 5 Jars system.**

## 🚀 Tech Stack

### Frontend
- **Flutter**: Cross-platform UI framework in Dart

### Backend
- **Spring Boot**: Robust REST API and business logic. The king of scalable and reliable backends
- **PostgreSQL**: Reliable relational data storage. Some even made fullstack apps with just postgres :))
- **COBOL**: The app's little neutron star. I just wanted to see if I could do it. Don't ask why, ask why not.

---

## 🛠️ Installation & Setup

### Environment Configuration
The project requires a `.env` file located in the **root directory** (same folder as this README). This file stores secrets mostly, that's why it's included in [.gitignore](./.gitignore)

**Create a `.env` file with the following template:**

```venv
# Database Configuration
POSTGRES_DB=five_jars_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
LOAD_SEEDS=true
# Security (JWT)
# Minimum 64-character base64 string recommended
JWT_SECRET_KEY=your_very_secure_secret_key_that_should_be_at_least_64_characters_long
JWT_EXPIRATION=11100000 # Token expiration time in milliseconds
```

## 📦 Deployment Options

This project supports multiple ways to get up and running depending on your workflow:
### A. The Full Kubernetes Experience (it's just cool)

For a production-like environment using `kind` (Kubernetes IN Docker).
Guide: see the [Kubernetes README](./infrastructure/k8s/README.md)

### B. Standalone Containers

If you want to run each piece separately for various reasons:

#### Postgres Guide

See the [Docker Compose README](./infrastructure/db/README.md) for instructions on setting up PostgreSQL with Docker Compose.

Key Command: ```docker compose up -d```

#### Spring Boot Guide
Ensure a PostgreSQL instance is running

Run `./gradlew bootRun` with arguments for the active profile from `backend/spring_api` or use the Dockerfile to build and run the Spring Boot app in a container

## 📂 Project Structure
```
.
├── backend
│   ├── cobol_microservice # The COBOL microservice source code
│   └── spring_api # The Spring Boot backend source code
│
├── flutter_frontend # The Flutter frontend source code
│
├── infrastructure
│   ├── db # Database migrations, seeds and the docker compose file
│   └── k8s # Kubernetes manifests for development and production
└── README.md
```