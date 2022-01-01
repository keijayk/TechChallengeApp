# Explicit declaration of dependency on more providers.
# Their configuration is being passed from the main module.
terraform {
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  
}