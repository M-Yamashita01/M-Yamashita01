terraform {
  required_version = ">= 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
  }

  # To keep state off your laptop, uncomment and configure a remote backend.
  # backend "s3" {
  #   bucket = "my-tfstate"
  #   key    = "github-repos/terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}
