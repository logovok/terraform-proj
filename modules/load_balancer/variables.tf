variable "vpc_id" {}

variable "app_instance_id" {}

variable "security_group_load_balancer_ids" {}

variable "subnet_ids" {}

variable "domain" {
}

variable "name" {
  default = "vprofile-app"
}

variable "health_check" {
  type = map
  default = {
    "path"  = "/login"
    "port" = "8080"
    "healthy_threshold" = "3"
    "unhealthy_threshold" = "2"
    "timeout" = "5"
    "interval" = "30"
  }
}