resource "helm_release" "app" {
  name       = "my-app-release"

  # Reference the chart folder relative to the root execution
  chart      = "${path.root}/../../helm/my-app"

  namespace        = "default"
  create_namespace = true
  timeout          = 600

  # Inject dynamic data from ECR and EKS modules
  set {
    name  = "image.repository"
    value = var.ecr_repo_url
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}