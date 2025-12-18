variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
  default = "my-eks-cluster"
}

variable "aws_region" {
  type    =  string
  default = "ap-south-1"
}

variable "node_group_name" {
  type        = string
  description = "Name of the managed node group"
  default = "test-managed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where nodes will be launched"
  default = ["subnet-083dfd6a780bd14ee","subnet-016afa71145aea48c"]
}

variable "nodegroup_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "List of instance types (e.g., t3.medium, m5.large)"
}

variable "release_version" {
  type        = string
  description = "AMI version of the EKS worker nodes"
  default     = null # If null, EKS uses the latest for the cluster version
}


variable "max_size" {
  description = "Maximum no of nodes"
  type        = number
  default = 3
}

variable "min_size" {
  description = "Minimum no of nodes"
  type        = number
  default = 1
}

variable "desired_size" {
  description = "desired no of nodes"
  type        = number
  default = 2
}

variable "security_group_ids" {
  description = "Communication between control plane and worker nodes"
  type    = list(string)
  default = []
}


################### cluster


variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

#variable "sg_ports"{
#  type = list
#  default = []
#}


# Node Group configuration as a map of maps
#variable "scaling_config" {
#  description = "Scaling Groups configurations."
#  type        = list(any)
#}


