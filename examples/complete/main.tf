# Every input, with the tenant uuid from a variable and every output exported
# for the Vulnetix console's AWS integration. From the registry, use
# source = "Vulnetix/aws-onboarding/vulnetix" with a version.

variable "vulnetix_tenant_uuid" {
  description = "Your Vulnetix tenant uuid, from the console's organisation settings."
  type        = string
}

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

output "auditor_role_arn" {
  description = "Paste into the Vulnetix console's AWS integration."
  value       = module.vulnetix_onboarding.auditor_role_arn
}

output "log_bucket_name" {
  description = "Where CloudTrail delivers."
  value       = module.vulnetix_onboarding.log_bucket_name
}

output "stack_id" {
  description = "The bootstrap stack."
  value       = module.vulnetix_onboarding.stack_id
}
