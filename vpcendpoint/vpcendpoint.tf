variable "vpc_id" {
  type = string
}
variable "endpoint_service_name" {
  type = string
  description = "For AWS services the service name is usually in the form com.amazonaws.<region>.<service>"
}
variable "vpc_endpoint_type" {
  type = string
  default = "Gateway"
}
variable "private_dns_enabled" {
  type = bool
  default = false
}
variable "endpoint_policy" {
  type = string
  default = ""
}
variable "endpoint_subnet_ids" {
  type = list(string)
  default = []
}
variable "endpoint_security_group_ids" {
  type = list(string)
  default = []
}
variable "endpoint_route_table_ids" {
  type = list(string)
  default = []
}

variable "endpoint_tags" {
  type = map(string)
  default = {
      "Terraform" = "true"
  }
}

variable "vpc_create_vpcendpoint" {
  type = bool
  default = false
}
resource "aws_vpc_endpoint" "service" {
  count = var.vpc_create_vpcendpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = var.endpoint_service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  private_dns_enabled = var.private_dns_enabled
  policy              = var.endpoint_policy
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_security_group_ids
  route_table_ids     = var.endpoint_route_table_ids
  tags                = var.endpoint_tags
}


output "vpcendpoint_id" {
  value = aws_vpc_endpoint.service.*.id
}

output "vpcendpoint_dns_host" {
  value = aws_vpc_endpoint.service.*.dns_entry
}
