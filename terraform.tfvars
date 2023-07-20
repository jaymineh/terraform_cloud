region = "us-east-1"

vpc_cidr = "10.0.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "DEV"

max_subnets = 20

name = "project19"

ami-web = "ami-026ebd4cfe2c043b2"

ami-bastion = "ami-026ebd4cfe2c043b2"

ami-nginx = "ami-026ebd4cfe2c043b2"

ami-sonar = "ami-026ebd4cfe2c043b2"

keypair = "Jemine-EC4"


account_no = 894194274688

master-username = "admin"

master-password = "password"

#db-username = "admin"

#db-password = "password"

tags = {
 # Enviroment      = "production"
  Owner-Email     = "jemine@iceglobalv.onmicrosoft.com"
  Managed-By      = "Terraform"
 # Billing-Account = "1234567890"
}