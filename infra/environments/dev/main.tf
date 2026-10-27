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

# AWS Backend
module "aws_backend" {
  source = "../../modules/aws"

  project_name              = var.project_name
  environment               = var.environment
  aws_region                = var.aws_region
  image_tag                 = var.image_tag
  db_name                   = var.db_name
  db_username               = var.db_username
  frontend_origin           = module.azure_frontend.frontend_url
  alert_email               = var.alert_email
  aws_monthly_budget_amount = var.aws_monthly_budget_amount
  monthly_budget_amount     = var.aws_monthly_budget_amount

  depends_on = [module.azure_frontend]
}