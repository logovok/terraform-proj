variable "artifact_source" {}

variable "bucket_id" {
  default = ""
  description = "If not specified new bucket is created. If specified artifact is uploaded there."
}

variable "artifact_key" {
  default = "artifact.war"
}

variable "bucket" {
  default = "your-bucket-for-artifact"
}