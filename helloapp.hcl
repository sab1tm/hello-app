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
        command = "local/hello-app-main/start.sh"
        ports = ["http"]
        network_mode = "host"
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
