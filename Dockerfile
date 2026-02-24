# Stage 1: Build the Spring Boot jar
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /build

COPY pom.xml .
COPY src ./src

# Build the jar
RUN mvn -B -DskipTests package

# Stage 2: Small runtime image
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the jar built in the previous stage
COPY --from=builder /build/target/*.jar app.jar

# Expose backend port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]