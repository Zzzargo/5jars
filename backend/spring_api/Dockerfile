# Build the container in 2 stages: building and running, to minimize compatibility issues. This is the industry standard
# Disclaimer: the image should be built from the root of the project for the paths to be valid
# --- Stage 1: Build ---
FROM eclipse-temurin:25-jdk-noble AS build
WORKDIR /app

# Copy gradle files for caching
COPY backend/spring_api/gradlew .
COPY backend/spring_api/gradle gradle
COPY backend/spring_api/build.gradle.kts .
COPY backend/spring_api/settings.gradle.kts .

# Download dependencies
RUN chmod +x ./gradlew
RUN ./gradlew dependencies --no-daemon

# Copy source and build the JAR
COPY backend/spring_api/src src
RUN ./gradlew bootJar --no-daemon

# --- Stage 2: Runtime ---
FROM eclipse-temurin:25-jre-noble
WORKDIR /app

# Create a non-root user for security
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

# Copy the JAR from build stage
# TODO: the wildcard copy is kinda inaccurate
COPY --from=build /app/build/libs/*.jar app.jar

# IMPORTANT: Bake the migrations into the image for K8s so the container is self-contained
COPY infrastructure/db/migrations /app/migrations
COPY infrastructure/db/seeds /app/seeds

# Exposed port on the container
EXPOSE 8080

# Configure JVM for container environments
ENTRYPOINT ["java", "-XX:+UseParallelGC", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]