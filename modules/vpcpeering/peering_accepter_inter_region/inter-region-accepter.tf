variable "peer_auto_accept_inter_region_connection" {
  type = bool
  default = true
}
variable "vpc_peering_id" {
  type = string
  default = ""
}
variable "peer_tags" {
  type = map(string)
  default = {
    "Source" = "Managed by Terraform"
  }
}
resource "aws_vpc_peering_connection_accepter" "accept_connection" {
  count = var.peer_auto_accept_inter_region_connection ? 1 : 0
  vpc_peering_connection_id = var.vpc_peering_id
  auto_accept               = true
  tags                      = var.peer_tags
}