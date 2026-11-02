# Only the required input: your Vulnetix tenant uuid. From the registry, use
# source = "Vulnetix/aws-onboarding/vulnetix" with a version.

provider "aws" {
  region = "us-east-1"
}

module "vulnetix_onboarding" {
  source = "../.."

  external_id = "6f1c2d3e-4a5b-4c6d-8e7f-90a1b2c3d4e5"
}
