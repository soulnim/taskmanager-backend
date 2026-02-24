# syntax=docker/dockerfile:1

# -----------------------
# Stage 1: Build the Spring Boot jar
# -----------------------
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Copy Maven project files
COPY pom.xml ./
COPY src ./src

# Build the jar without running tests
RUN mvn -B -DskipTests package

# -----------------------
# Stage 2: Runtime image
# -----------------------
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the jar built in the previous stage
COPY --from=builder /build/target/taskmanager-backend-0.0.1-SNAPSHOT.jar app.jar

# Expose backend port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]