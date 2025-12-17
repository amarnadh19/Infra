variable "image_tag_mutability" {
  description = "The tag mutability setting (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE" # Recommended for Prod to ensure unique SHAs
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned for vulnerabilities after being pushed"
  type        = bool
  default     = false
}

variable "untagged_retention_days" {
  description = "Days to retain untagged images before expiring them"
  type        = number
  default     = 14
}
variable "repository_name" {}