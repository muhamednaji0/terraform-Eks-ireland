terraform {
  backend "s3" {
    bucket       = "terraform-statefile-te-st-bu"
    key          = "eks/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
