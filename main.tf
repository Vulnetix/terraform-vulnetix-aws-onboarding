# The Vulnetix AWS onboarding bootstrap: the CloudTrail log bucket and the
# VulnetixSecurityAuditor role Vulnetix assumes, as the same CloudFormation
# stack the console deploys (templates/aws-bootstrap.yaml).
#
# The stack name is fixed. The console finds its progress by stack name, the
# role's own policy only lets Vulnetix manage the stacks named
# vulnetix-security-bootstrap and vulnetix-security-pipeline, and Vulnetix
# deploys the pipeline stack itself, through the role, once this one exists.
# So an account has one of these, in the region its trail should log from.

locals {
  stack_name = "vulnetix-security-bootstrap"
  tags       = merge({ ManagedBy = "terraform" }, var.tags)
}

resource "aws_cloudformation_stack" "bootstrap" {
  name          = local.stack_name
  template_body = file("${path.module}/templates/aws-bootstrap.yaml")
  capabilities  = ["CAPABILITY_NAMED_IAM"]
  on_failure    = "ROLLBACK"

  parameters = {
    ExternalId        = var.external_id
    VulnetixAccountId = var.vulnetix_account_id
  }

  tags = local.tags

  # on_failure only applies at create time and the CloudFormation API never
  # returns it, so after importing a stack the console already deployed it reads
  # as null and Terraform plans to replace the stack: deleting the auditor role and
  # the log bucket. Ignore it so an import is an in-place adoption.
  lifecycle {
    ignore_changes = [on_failure]
  }

  timeouts {
    create = "${var.timeout_minutes}m"
    update = "${var.timeout_minutes}m"
    delete = "${var.timeout_minutes}m"
  }
}
