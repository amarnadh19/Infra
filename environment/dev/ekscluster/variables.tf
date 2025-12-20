#variable "vpc_id" {}
variable "vpc_id" {
  description = "VPC ID passed from the common module"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs passed from the common module"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}
