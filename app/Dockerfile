# ---------- Build ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /ws
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# ---------- Runtime ----------
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /ws/target/*.jar app.jar
ENV JAVA_TOOL_OPTIONS=""
ENV DOWNSTREAM_URL="https://httpbin.org/delay/1"
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
