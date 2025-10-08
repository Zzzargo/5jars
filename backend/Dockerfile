# Use Ubuntu as base for COBOL and Python environment
FROM ubuntu:24.04

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc \
        gnucobol \
        python3 \
        python3-venv \
        python3-pip \
        cmake \
        && rm -rf /var/lib/apt/lists/*

# Create a virtual environment for Python because pip cries
RUN python3 -m venv /opt/venv

# Install Python dependencies
RUN /opt/venv/bin/pip install --no-cache-dir \
    flask mysql-connector-python python-dotenv

# Ensure the virtual environment is used:
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /5jars_backend

# Copy backend sources
COPY ./flask ./flask
COPY ./cobol ./cobol
COPY ./db ./db

# Build COBOL and C code via Cmake
WORKDIR /5jars_backend/cobol
RUN rm -rf build && mkdir build && cd build && cmake .. && make

# From this point only the Flask app needs to run
WORKDIR /5jars_backend/flask

# Expose Flask port on the container
EXPOSE 5000

# Run Flask
CMD ["python3", "app.py"]
