output "auditor_role_arn" {
  description = "The VulnetixSecurityAuditor role Vulnetix assumes. Give it, with the account id, to the Vulnetix console's AWS integration."
  value       = aws_cloudformation_stack.bootstrap.outputs["AuditorRoleArn"]
}

output "log_bucket_name" {
  description = "The bucket CloudTrail delivers into and the Vulnetix probe bundle is staged in."
  value       = aws_cloudformation_stack.bootstrap.outputs["LogBucketName"]
}

output "external_id" {
  description = "The external ID the role requires: your tenant uuid."
  value       = var.external_id
}

output "stack_id" {
  description = "The bootstrap CloudFormation stack's id."
  value       = aws_cloudformation_stack.bootstrap.id
}
