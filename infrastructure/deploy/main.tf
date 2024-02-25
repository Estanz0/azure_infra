###########################
# Existing Infrastructure #
###########################

# Subscription
data "azurerm_subscription" "default" {}

# SPN
data "azurerm_client_config" "current" {}

############################
# Terraform Infrastructure #
############################

# Resource Group
resource "azurerm_resource_group" "default" {
  name     = "rg-${var.project_id}-${var.env}-eau"
  location = var.location
}

# App Service Plan
resource "azurerm_service_plan" "default" {
  name                = "asp-${var.project_id}-${var.env}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  os_type  = var.asp_os_type
  sku_name = var.asp_sku_name
}

# Github
data "github_repository" "repo" {
  full_name = "${var.gh_repo_owner}/${var.gh_repo_name}"
}

resource "github_actions_environment_variable" "action_variable_fa_name" {
  repository    = data.github_repository.repo.name
  environment   = var.env
  variable_name = "APP_SERVICE_PLAN_NAME"
  value         = azurerm_service_plan.default.name
}