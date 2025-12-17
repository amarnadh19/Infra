resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256" # Standard AWS encryption
  }
}
# resource "aws_ecr_lifecycle_policy" "cleanup" {
#   repository = aws_ecr_repository.this.name

#   policy = jsonencode({
#     rules = [{
#       rulePriority = 1
#       description  = "Expire untagged images older than ${var.untagged_retention_days} days"
#       selection = {
#         tagStatus   = "untagged"
#         countType   = "sinceImagePushed"
#         countUnit   = "days"
#         countNumber = var.untagged_retention_days
#       }
#       action = {
#         type = "expire"
#       }
#     }]
#   })
# }