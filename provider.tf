

terraform {
  backend "s3" {
    bucket = "tfstate-cicd"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}