# Every input, with the tenant uuid from a variable and every output exported
# for the Vulnetix console's AWS integration. From the registry, use
# source = "Vulnetix/aws-onboarding/vulnetix" with a version.

provider "aws" {
  region = "eu-west-1"
}

module "vulnetix_onboarding" {
  source = "../.."

  external_id         = var.vulnetix_tenant_uuid
  vulnetix_account_id = "061882422009"
  timeout_minutes     = 45

  tags = {
    Owner       = "security-platform"
    CostCentre  = "sec-1234"
    Environment = "production"
  }
}
