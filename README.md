# terraform-vulnetix-aws-onboarding

Connects an AWS account to Vulnetix. It deploys the same `vulnetix-security-bootstrap` CloudFormation stack the Vulnetix console deploys, which holds two things:

- `vulnetix-cloudtrail-<account id>`: the CloudTrail log bucket, private and encrypted, writable only by this account's Vulnetix trail.
- `VulnetixSecurityAuditor`: the role Vulnetix assumes. It trusts only the Vulnetix AWS account, and only with your tenant uuid as the external ID.

Vulnetix then uses the role to deploy the `vulnetix-security-pipeline` stack: the trail, the EventBridge rule, the queue and the Vulnetix probe. The role's policy is scoped to exactly those two stacks and the resources they declare.

## Usage

```hcl
module "vulnetix_onboarding" {
  source  = "Vulnetix/aws-onboarding/vulnetix"
  version = "~> 1.0"

  external_id = "<your Vulnetix tenant uuid>"
}

output "auditor_role_arn" {
  value = module.vulnetix_onboarding.auditor_role_arn
}
```

Apply it with credentials that can create IAM roles, such as an IAM Identity Center administrator. Then give the account id and `auditor_role_arn` to the AWS integration in the Vulnetix console, which deploys the pipeline stack and verifies log delivery.

One account has one bootstrap stack. Deploy it in the region the trail should log from. The stack name is fixed, because the console and the role's policy both refer to it.

- [examples/minimal](examples/minimal): the required input only.
- [examples/complete](examples/complete): every input and output.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `external_id` | Your Vulnetix tenant (organisation) uuid. The role only trusts an assume that carries it as the external ID. | `string` | n/a | yes |
| `vulnetix_account_id` | The AWS account the Vulnetix service assumes the role from. Change it only when Vulnetix support asks you to. | `string` | `"061882422009"` | no |
| `tags` | Tags for the stack. CloudFormation copies them onto every resource it creates. `ManagedBy = "terraform"` is always added. | `map(string)` | `{}` | no |
| `timeout_minutes` | How long to wait for the stack to create, update or delete. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| `auditor_role_arn` | The `VulnetixSecurityAuditor` role. Give it to the Vulnetix console. |
| `log_bucket_name` | The bucket CloudTrail delivers into and the probe bundle is staged in. |
| `external_id` | The external ID the role requires: your tenant uuid. |
| `stack_id` | The bootstrap stack's id. |

## Requirements

| Name | Version |
|------|---------|
| terraform or OpenTofu | >= 1.5.0 |
| hashicorp/aws | >= 5.0 |

## The template

`templates/aws-bootstrap.yaml` is a copy of the template the Vulnetix console deploys, so a stack made here and one made from the console are the same stack. `scripts/sync-template.sh` refreshes the copy from Vulnetix's source; the first lines of the file name the revision it came from. Do not edit the copy.

## Removing it

`terraform destroy` deletes the stack. Remove the pipeline stack first, from the Vulnetix console or with `aws cloudformation delete-stack --stack-name vulnetix-security-pipeline`, since it is deployed with the role this stack holds. CloudFormation cannot delete the log bucket while it holds objects; empty it first.

## Development

CI runs `terraform fmt -check`, `terraform validate` and `tflint` (with the AWS ruleset) on the module and both examples.

## License

[MPL-2.0](LICENSE)
