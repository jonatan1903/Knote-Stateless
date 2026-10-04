# Stage 1: Compilar la aplicación con Maven y JDK 11
FROM maven:3.8.8-eclipse-temurin-11-alpine AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Imagen de ejecución con JRE 11
FROM eclipse-temurin:11-jre-alpine
WORKDIR /opt
ENV PORT=8080
EXPOSE 8080
COPY --from=builder /app/target/*.jar /opt/app.jar
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]