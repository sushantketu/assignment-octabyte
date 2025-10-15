
terraform {
  backend "s3" {
    bucket = "flyingsushantketu"
    key    = "eks/terraform.tfstate"
    region = var.region
  }
}
