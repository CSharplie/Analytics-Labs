
variable "prefix" {}
variable "location" {}
variable "environment" {}

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

resource "azurerm_resource_group" "rg" {
	name						= "adf_hands_on_${var.environment}"
	location					= var.location
}

resource "azurerm_data_factory" "adf" {
	name						= "${var.prefix}-handson-adf-${var.environment}" 
	location					= var.location
	resource_group_name			= azurerm_resource_group.rg.name
}

resource "azurerm_key_vault" "akv" {
	name						= "${var.prefix}-handson-akv-${var.environment}"
	location					= var.location
	resource_group_name 		= azurerm_resource_group.rg.name
	enabled_for_disk_encryption	= true
	tenant_id					= data.azurerm_client_config.current.tenant_id
	soft_delete_retention_days	= 7
	purge_protection_enabled	= false
	sku_name					= "standard"
}
