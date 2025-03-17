terraform {
  backend "azurerm" {
    resource_group_name     = "rg-infraestrutura-001"
    storage_account_name    = "stinfradevops01"
    container_name          = "terraform"
    key                     = "terraform.tfstate"
  }
}