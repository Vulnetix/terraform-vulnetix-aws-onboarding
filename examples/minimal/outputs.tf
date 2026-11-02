output "auditor_role_arn" {
  description = "Paste into the Vulnetix console's AWS integration."
  value       = module.vulnetix_onboarding.auditor_role_arn
}
