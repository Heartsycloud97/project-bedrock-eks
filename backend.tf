terraform {
  backend "s3" {
    bucket       = "bedrock-terraform-state-alt-soe-025-0259"
    key          = "project-bedrock/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
