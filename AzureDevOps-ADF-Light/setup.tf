variable "prefix" {
	type = string
	description = "Enter your trigram in lowercase (ex: Julien Schwarzer = jsc)"

	validation {
		condition     = can(regex("^[a-z]{3}$", var.prefix))
		error_message = "Please enter a value in lowercase with 3 characters."
	}
}

variable "location" {
	default 							= "westeurope"
}

module "resources_dev" {
	source								= "./resources"
	prefix								= var.prefix
	location							= var.location
	environment							= "dev"
}

module "resources_tst" {
	source								= "./resources"
	prefix								= var.prefix
	location							= var.location
	environment							= "tst"
}

