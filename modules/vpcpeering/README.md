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
| [aws_route.peering_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.create_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_route_table.add_peering_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_peer_routes"></a> [create\_peer\_routes](#input\_create\_peer\_routes) | n/a | `bool` | `true` | no |
| <a name="input_create_peering_connection"></a> [create\_peering\_connection](#input\_create\_peering\_connection) | n/a | `bool` | `true` | no |
| <a name="input_peer_acceptor_region"></a> [peer\_acceptor\_region](#input\_peer\_acceptor\_region) | n/a | `string` | `null` | no |
| <a name="input_peer_acceptor_vpc_id"></a> [peer\_acceptor\_vpc\_id](#input\_peer\_acceptor\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_peer_auto_accept_connection"></a> [peer\_auto\_accept\_connection](#input\_peer\_auto\_accept\_connection) | n/a | `bool` | `true` | no |
| <a name="input_peer_owner_id"></a> [peer\_owner\_id](#input\_peer\_owner\_id) | n/a | `string` | `null` | no |
| <a name="input_peer_requester_vpc_id"></a> [peer\_requester\_vpc\_id](#input\_peer\_requester\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_peer_route_cidr_block"></a> [peer\_route\_cidr\_block](#input\_peer\_route\_cidr\_block) | n/a | `list(string)` | `[]` | no |
| <a name="input_peer_subnets_association"></a> [peer\_subnets\_association](#input\_peer\_subnets\_association) | n/a | `list(string)` | `[]` | no |
| <a name="input_peer_tags"></a> [peer\_tags](#input\_peer\_tags) | n/a | `map(string)` | <pre>{<br/>  "Source": "Managed by Terraform"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_id"></a> [peering\_id](#output\_peering\_id) | n/a |
