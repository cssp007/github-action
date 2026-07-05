provider "aws" {
  region = var.aws_region
  allowed_account_ids = ["579750809369"]

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Demo"
      Owner       = "DevOps"
      CostCenter  = "IT"
      Application = "CSSP"
    }
  }
}
