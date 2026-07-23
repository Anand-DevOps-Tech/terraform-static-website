terraform {
  backend "s3" {
    bucket = "terraform-bucket-backendtf"
    key    = "static-website/terraform.tfstate"
    region = "us-east-1"
  }
}
