## The .env file should contain these environment variables:
### The already filled values should not be changed unless you develop locally
``` Python
FIVEJARS_MYSQL_ROOT_PASSWORD=
FIVEJARS_MYSQL_DATABASE=fivejars
FIVEJARS_MYSQL_USER=
FIVEJARS_MYSQL_USER_PASSWORD=
FIVEJARS_DB_HOST=db # Docker database service name
FIVEJARS_DB_PORT=3306 # Port on which the database service listens
```

## How to run the backend:

### Via docker compose (should be working but not stable yet)
1. Make sure you have Docker and Docker Compose installed on your machine.
2. Navigate to the backend directory:
   ```bash
   cd backend
   ```
3. Create a `.env.local` file in the `backend` directory with the required environment variables.
4. Run the following command to start the services:
   ```bash
   docker compose up
   ```
5. The backend service should now be running and accessible at `http://localhost:5000` on the host machine

### Locally
1. Make sure you have Python 3.10+, MySQL and gnucobol installed on your machine. The other dependencies will be pointed out by pip mostly
2. Navigate to the backend directory:
   ```bash
   cd backend
   ```
3. Create a `.env` file in the `backend` directory with the required environment variables.
4. Compile the cobol code via CMake:
    ```bash
    cd cobol
    mkdir build && cd build && cmake .. && make
    ```
5. Run the Flask app:
   ```bash
   cd ../flask
   python3 app.py
   ```
6. The backend service should now be running and accessible at `http://localhost:5000`