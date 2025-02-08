job "hello-app" {
  datacenters = ["dc1"]
  type = "service"

  group "hello-app" {
    count = 1

    network {
      port "http" {
        static = 8090
      }
    }

    task "build-and-run" {
      driver = "docker"

      config {
        image = "maven:3.9-amazoncorretto-17"
        command = "local/start.sh"
        ports = ["http"]
        network_mode = "host"
      }

      template {
              data = <<EOH
      #!/bin/sh
      WORK_DIR="/alloc/local/hello-app-main"
      echo "Working directory: $WORK_DIR"
      cd $WORK_DIR
      echo "Contents:"
      ls -la
      mvn -B clean package
      java -jar target/hello-0.0.1-SNAPSHOT.jar --server.port=${NOMAD_PORT_http} --spring.cloud.consul.enabled=false
      EOH
              destination = "local/start.sh"
              perms = "755"
            }

      artifact {
        source = "https://github.com/sab1tm/hello-app/archive/refs/heads/main.zip"
        destination = "local"
        options {
          archive = true
        }
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}
