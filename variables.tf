variable "external_id" {
  description = "Your Vulnetix tenant (organisation) uuid. The role only trusts an sts:AssumeRole that carries it as the external ID, so a third party who learns the role ARN still cannot use it."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]{8,64}$", var.external_id))
    error_message = "The external_id must be your Vulnetix tenant uuid: 8 to 64 letters, digits and hyphens."
  }
}

variable "vulnetix_account_id" {
  description = "The AWS account the Vulnetix service runs in and assumes the role from. Change it only when Vulnetix support asks you to."
  type        = string
  default     = "061882422009"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.vulnetix_account_id))
    error_message = "The vulnetix_account_id must be a 12-digit AWS account id."
  }
}

variable "tags" {
  description = "Tags for the CloudFormation stack. CloudFormation copies them onto every resource the stack creates."
  type        = map(string)
  default     = {}
}

variable "timeout_minutes" {
  description = "How long to wait for the stack to create, update or delete, in minutes."
  type        = number
  default     = 30
}
