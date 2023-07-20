# Push state file to cloud
terraform {
  backend "s3" {
    bucket         = "jmn-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}