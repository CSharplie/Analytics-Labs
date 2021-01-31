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

module "acm_request_certificate_example" {
  source                            = "./resources"
  prefix                            = var.prefix
  db_username                       = var.db_username
  db_password                       = var.db_password
  location                          = var.location
  ip                                = chomp(data.http.myip.body)
  environment                       = "dev"
}

module "acm_request_certificate_other_example" {
  source                            = "./resources"
  prefix                            = var.prefix
  db_username                       = var.db_username
  db_password                       = var.db_password
  location                          = var.location
  ip                                = chomp(data.http.myip.body)
  environment                       = "tst"
}