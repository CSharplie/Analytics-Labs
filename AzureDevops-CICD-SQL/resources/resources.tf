
variable "prefix" {}
variable "location" {}
variable "environment" {}
variable "ip" {}
variable "db_username" {}
variable "db_password" {}

terraform {
  required_providers {
  azurerm = {
      source                          = "hashicorp/azurerm"
      version                         = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name                                = "adf_hands_on_${var.environment}"
  location                            = var.location
}

resource "azurerm_sql_server" "dbserver" {
  name                                = "${var.prefix}-handson-sql-${var.environment}" 
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = var.location
  version                             = "12.0"
  administrator_login                 = var.db_username
  administrator_login_password        = var.db_password
}

resource "azurerm_sql_database" "db" {
  name                                = "${var.prefix}-handson-db-${var.environment}" 
  resource_group_name                 = azurerm_resource_group.rg.name
  location                            = var.location
  server_name                         = azurerm_sql_server.dbserver.name
  requested_service_objective_name    = "Basic"
  edition                             = "Basic"
  max_size_bytes                      = 2147483648
}

resource "azurerm_sql_firewall_rule" "db_fw" {
  name                                = "Current User"
  resource_group_name                 = azurerm_resource_group.rg.name
  server_name                         = azurerm_sql_server.dbserver.name
  start_ip_address                    = var.ip
  end_ip_address                      = var.ip
}

resource "azurerm_sql_firewall_rule" "db_fw_az" {
  name                                = "Azure Services"
  resource_group_name                 = azurerm_resource_group.rg.name
  server_name                         = azurerm_sql_server.dbserver.name
  start_ip_address                    = "0.0.0.0"
  end_ip_address                      = "0.0.0.0"
}

resource "azurerm_key_vault" "akv" {
  name                                = "${var.prefix}-handson-akv-${var.environment}"
  location                            = var.location
  resource_group_name                 = azurerm_resource_group.rg.name
  enabled_for_disk_encryption         = true
  tenant_id                           = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days          = 7
  purge_protection_enabled            = false
  sku_name                            = "standard"
}
