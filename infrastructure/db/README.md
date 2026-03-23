# 🐘 Standalone Database Launch Guide (Docker Compose)

This guide explains how to run the PostgreSQL database as a standalone service using Docker Compose

---

## 1. Prerequisites
* **Docker** & **Docker Compose** installed.
* A `.env` file in the root of the project with the necessary environment variables (see [the main README](../../README.md))

---

## 2. Usage Commands
- Start the Database

Run this command from the directory containing docker-compose.yml:
```Bash
docker compose up -d # -d runs it in detached mode (in the background)
```

- Stop the Database

```Bash
docker compose down
```

- Stop and Wipe Data (deletes the volume)

```Bash
docker compose down -v
```

## 3. Connection Details

When running via this compose file, the database is exposed directly to your host machine.

<table>
  <tr>
    <th>Property</th>
    <th>Value</th>
  </tr>
  <tr>
    <td>Host</td>
    <td>localhost</td>
  </tr>
  <tr>
    <td>Port</td>
    <td>5432</td>
  </tr>
  <tr>
    <td>User</td>
    <td>Defined in .env</td>
  </tr>
  <tr>
    <td>Database</td>
    <td>Defined in .env</td>
  </tr>
</table>

## 4. Troubleshooting & Logs
- The container includes a health check. You can verify if the DB is ready to accept connections:

```Bash
docker ps --filter name=five_jars_postgres_dev # Look for (healthy) in the STATUS column
```

- View Database Logs

```Bash
docker logs -f five_jars_postgres_dev
```

- Access Interactive Shell (psql)
```Bash
docker exec -it five_jars_postgres_dev psql -U your_user -d five_jars_db -h localhost -p 5432
```