# Explicit declaration of dependency on more providers.
# Their configuration is being passed from the main module.
terraform {
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

provider "azuread" {
   version = ">=0.7.0"
   tenant_id = "ab078f81-xxxx-xxxx-xxxx-620b694ded30"
}