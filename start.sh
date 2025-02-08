#!/bin/sh
set -e  # остановка при любой ошибке
set -x  # вывод выполняемых команд

echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

echo "Starting Maven build..."
mvn -B clean package

echo "Directory contents after build:"
ls -la target/

echo "Starting Spring Boot application..."
java -jar target/hello-0.0.1-SNAPSHOT.jar \
  --server.port=${NOMAD_PORT_http} \
  --spring.cloud.consul.enabled=false
