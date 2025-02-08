#!/bin/sh
mvn -B clean package
java -jar target/hello-0.0.1-SNAPSHOT.jar --server.port=${NOMAD_PORT_http} --spring.cloud.consul.enabled=false
