job "spring-boot-web" {
  type="service"
  datacenters = ["dc1"]
  group "ui" {
    count = 3
    task "app" {
      driver="java"
      config {
        jar_path = "local/spring-boot-sample-web.jar"  
	jvm_options = ["-Xmx128m","-Xms128m"]
      }
      artifact {
        source = "http://192.168.56.10:8000/spring-boot-sample-web.jar"
      }
      service {
        port = "http"
      }
      resources {
        network {
          port "http" {}
        }
        memory = 128 # MB
      }
    }
  }
}
