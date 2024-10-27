variable "vpc_id" {
  type = string
  default = ""
}
variable "create_nacl" {
  type = bool
  default = true
}
variable "create_nacl_rules" {
  type = bool
  default = true
}
variable "nacl_tags" {
  type = map(any)
}

variable "naclrule_number" {
  type = list(number)
  default = [100]
}
variable "nacl_egress" {
  type = list(bool)
}

variable "nacl_protocol" {
  type = list(string)
}
variable "nacl_rule_action" {
  type = list(string)
}
variable "nacl_cidr_blocks" {
  type = list(string)
}
variable "nacl_from_port" {
  type = list(number)
}
variable "nacl_to_port" {
  type = list(number)
}
variable "nacl_subnet_ids" {
  type = list(string)
}
resource "aws_network_acl" "nacl" {
  count = var.create_nacl ? 1 : 0
  vpc_id = var.vpc_id
  subnet_ids = var.nacl_subnet_ids
  tags = var.nacl_tags
}

resource "aws_network_acl_rule" "nacl_rule" {
  count = var.create_nacl && var.create_nacl_rules ? length(var.nacl_egress) : 0
  network_acl_id = aws_network_acl.nacl.0.id
  rule_number    = var.naclrule_number[count.index]
  egress         = var.nacl_egress[count.index]
  protocol       = var.nacl_protocol[count.index]
  rule_action    = var.nacl_rule_action[count.index]
  cidr_block     = var.nacl_cidr_blocks[count.index]
  from_port      = var.nacl_from_port[count.index]
  to_port        = var.nacl_to_port[count.index]
  depends_on = [
    aws_network_acl.nacl
  ]
}

output "nacl_id" {
  value = join("",aws_network_acl.nacl.*.id)
}
output "naclrule_id" {
  value = aws_network_acl_rule.nacl_rule.*.id
}