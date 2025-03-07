## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.nacl_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nacl"></a> [create\_nacl](#input\_create\_nacl) | n/a | `bool` | `true` | no |
| <a name="input_create_nacl_rules"></a> [create\_nacl\_rules](#input\_create\_nacl\_rules) | n/a | `bool` | `true` | no |
| <a name="input_nacl_cidr_blocks"></a> [nacl\_cidr\_blocks](#input\_nacl\_cidr\_blocks) | n/a | `list(string)` | n/a | yes |
| <a name="input_nacl_egress"></a> [nacl\_egress](#input\_nacl\_egress) | n/a | `list(bool)` | n/a | yes |
| <a name="input_nacl_from_port"></a> [nacl\_from\_port](#input\_nacl\_from\_port) | n/a | `list(number)` | n/a | yes |
| <a name="input_nacl_protocol"></a> [nacl\_protocol](#input\_nacl\_protocol) | n/a | `list(string)` | n/a | yes |
| <a name="input_nacl_rule_action"></a> [nacl\_rule\_action](#input\_nacl\_rule\_action) | n/a | `list(string)` | n/a | yes |
| <a name="input_nacl_subnet_ids"></a> [nacl\_subnet\_ids](#input\_nacl\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_nacl_tags"></a> [nacl\_tags](#input\_nacl\_tags) | n/a | `map(any)` | n/a | yes |
| <a name="input_nacl_to_port"></a> [nacl\_to\_port](#input\_nacl\_to\_port) | n/a | `list(number)` | n/a | yes |
| <a name="input_naclrule_number"></a> [naclrule\_number](#input\_naclrule\_number) | n/a | `list(number)` | <pre>[<br/>  100<br/>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nacl_id"></a> [nacl\_id](#output\_nacl\_id) | n/a |
| <a name="output_naclrule_id"></a> [naclrule\_id](#output\_naclrule\_id) | n/a |
