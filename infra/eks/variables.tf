variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  default     = ""
  sensitive   = true
}
