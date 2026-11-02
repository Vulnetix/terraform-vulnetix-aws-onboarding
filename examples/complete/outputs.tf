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
