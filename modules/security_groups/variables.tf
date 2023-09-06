variable "vpc_id" {}

variable "environment" {
  type = string
  description = "value"
}

variable "debug_connection_ip" {}

variable "load_balancer_ports" {
  type = list(string)
  default = ["80", "443"]
}

variable "tomcat_production_ports" {
  type = list(string)
  default = ["8080"]
}

variable "tomcat_debug_ports" {
  type = list(string)
  default = ["22", "8080"]
}

variable "backend_production_ports" {
  type = list(string)
  default = ["3306", "5672","11211"]
}

variable "backend_debug_ports" {
  type = list(string)
  default = ["22", "8080"]
}