# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/PlateHop-0.0.1-SNAPSHOT.war app.war
ENV PORT=8081
ENV DB_URL=jdbc:h2:mem:platehop_db;DB_CLOSE_DELAY=-1;MODE=MySQL
ENV DB_DRIVER=org.h2.Driver
ENV DB_USERNAME=sa
ENV DB_PASSWORD=
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.war"]
