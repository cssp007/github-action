variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_name" {
  type = string
  description = "VPC name"
  default = "dev-vpc" 
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
  default = "10.0.0.0/16"
}


variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))

  default = {
    public-1 = {
      cidr = "10.0.1.0/24"
      az   = "ap-south-2a"
    }

    public-2 = {
      cidr = "10.0.2.0/24"
      az   = "ap-south-2b"
    }
  }
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))

  default = {
    private-1 = {
      cidr = "10.0.11.0/24"
      az   = "ap-south-2a"
    }

    private-2 = {
      cidr = "10.0.12.0/24"
      az   = "ap-south-2b"
    }
  }
}