variable "prefix" {
    type = string
    description = "Prefix for resources names"
}

variable "db_username" {
    type = string
    description = "Database admin account"
}

variable "db_password" {
    type = string
    description = "Database admin password"
}

variable "location" {
	default = "westeurope"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

// DEV Resources

resource "azurerm_resource_group" "rg_dev" {
  name     = "adf_hands_on_dev"
  location = var.location
}

resource "azurerm_sql_server" "dbserver_dev" {
  name                         = "${var.prefix}-sql-dev" 
  resource_group_name          = azurerm_resource_group.rg_dev.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.db_username
  administrator_login_password = var.db_password
}

resource "azurerm_sql_database" "db_dev" {
  name                = "${var.prefix}-db-dev" 
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = var.location
  server_name         = azurerm_sql_server.dbserver_dev.name
}

resource "azurerm_sql_firewall_rule" "db_fw_dev" {
  name                = "Current User"
  resource_group_name = azurerm_resource_group.rg_dev.name
  server_name         = azurerm_sql_server.dbserver_dev.name
  start_ip_address    = chomp(data.http.myip.body)
  end_ip_address      = chomp(data.http.myip.body)
}

resource "azurerm_sql_firewall_rule" "db_fw_az_dev" {
  name                = "Azure Services"
  resource_group_name = azurerm_resource_group.rg_dev.name
  server_name         = azurerm_sql_server.dbserver_dev.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_data_factory" "adf_dev" {
  name                = "${var.prefix}-adf-dev" 
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_dev.name
}

resource "azurerm_key_vault" "akv_dev" {
  name                        = "${var.prefix}-akv-dev"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg_dev.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}
