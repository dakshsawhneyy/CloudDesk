resource "terraform_data" "project_foundation" {
  input = {
    project_name = var.project_name
    environment  = var.environment
    managed_by   = "terraform"
  }
}

# Azure Module
module "azure_frontend" {
  source = "../../modules/azure"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.azure_location
  static_web_app_name = var.static_web_app_name
}