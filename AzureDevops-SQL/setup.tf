variable "prefix" {
	type 				      = string
	description 		  = "Enter your trigram in lowercase (ex: Julien Schwarzer = jsc)"

	validation {
		condition	 	    = can(regex("^[a-z]{3}$", var.prefix))
		error_message 	= "Please enter a value in lowercase with 3 characters."
	}
}

variable "db_username" {
	type 				      = string
	default 			    = "HandsOn"
}

variable "db_password" {
	type 				      = string
	default 			    = "PixelAnalytics$$92130"
}

variable "location" {
	type 				      = string
	default 			    = "westeurope"
}

data "http" "myip" {
	url 				      = "http://ipv4.icanhazip.com"
}

module "resources_dev" {
	source				    = "./resources"
	prefix				    = var.prefix
	db_username			  = var.db_username
	db_password			  = var.db_password
	location			    = var.location
	ip					      = chomp(data.http.myip.body)
	environment			  = "dev"
}

module "resources_tst" {
	source				    = "./resources"
	prefix				    = var.prefix
	db_username			  = var.db_username
	db_password			  = var.db_password
	location			    = var.location
	ip					      = chomp(data.http.myip.body)
	environment		  	= "tst"
}