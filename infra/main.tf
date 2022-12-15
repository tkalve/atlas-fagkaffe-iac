terraform {
  backend "azurerm" {
    resource_group_name  = "atlas-infra-rg"
    storage_account_name = "atlasinfrastorage"
    container_name       = "tfstate"
    key                  = "fagkaffe.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    "Enhet"   = "Atlas"
    "Teknisk" = var.technicalcontact
  }
}

resource "azurerm_resource_group" "this" {
  name     = "atlas-fagkaffe-rg"
  location = var.location

  tags = local.tags
}

resource "azurerm_mssql_server" "this" {
  name                         = "atlas-fagkaffe-sql"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = "nimda"
  administrator_login_password = "correct horse battery staple!1"
}

# resource "azurerm_mssql_database" "this" {
#   name      = "vinlotteridb"
#   server_id = azurerm_mssql_server.this.id
#   sku_name  = "S0"

#   tags = local.tags
# }
