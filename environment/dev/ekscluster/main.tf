module "ecr_repo1" {
    source = "../../../modules/ecr"
    repository_name = "demo_repo_app"
}