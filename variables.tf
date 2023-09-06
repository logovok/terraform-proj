variable "environment" {
  type = string
  description = "Could be set to 'debug' to allow ssh for specifyed ip addresses"
  # Check security_groups module for more detail
  default = "production"
}

variable "debug_connection_ip" {
  type = list(string)
  description = "If environment set to 'debug' ssh will be allowed for these ip addresses"
  default = ["127.0.0.1/32"]
}

variable "artifact_source" {
  type = string
  default = "./vprofile-v2.war"
}

variable "bucket_name" {
  default = "your-bucket-for-artifact"
}

variable "domain_name" {
# Optional
  type = string
  default = ""
}
