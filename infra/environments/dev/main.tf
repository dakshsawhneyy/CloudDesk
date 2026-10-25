resource "terraform_data" "project_foundation" {
  input = {
    project_name = var.project_name
    environment  = var.environment
    managed_by   = "terraform"
  }
}