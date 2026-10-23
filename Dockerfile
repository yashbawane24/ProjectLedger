# Stage 1: Build application with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build production WAR package
RUN mvn clean package -DskipTests

# Stage 2: Runtime environment with Apache Tomcat 10.1 (Jakarta EE 10)
FROM tomcat:10.1-jdk17-temurin

# Remove default sample webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable Tomcat shutdown listener port so cloud proxies and health checks only target the web connector
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Enable HTTP GZIP compression on Tomcat connector (compresses HTML, CSS, JS, JSON payloads by ~80%)
RUN sed -i 's/<Connector port="8080"/<Connector port="8080" compression="on" compressionMinSize="1024" compressableMimeType="text\/html,text\/xml,text\/plain,text\/css,text\/javascript,application\/javascript,application\/json"/' /usr/local/tomcat/conf/server.xml

# Deploy project as the ROOT application
COPY --from=builder /build/target/projectledger.war /usr/local/tomcat/webapps/ROOT.war

# JVM tuning for container performance & fast non-blocking entropy
ENV CATALINA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=40.0 -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080

# Dynamically bind to cloud provider $PORT if provided, else default to 8080
CMD ["sh", "-c", "if [ -n \"$PORT\" ]; then sed -i \"s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/\" /usr/local/tomcat/conf/server.xml; fi && catalina.sh run"]
