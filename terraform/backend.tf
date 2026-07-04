terraform {
  backend "s3" {
    bucket         = "cssp-terraform-state-bucket"
    key            = "dev/network/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
