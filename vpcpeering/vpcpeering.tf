variable "create_peering_connection" {
  type = bool
  default = true
}
variable "peer_acceptor_vpc_id" {
  type = string
}
variable "peer_requester_vpc_id" {
  type = string
}
variable "peer_auto_accept_connection" {
  type = bool
  default = true
}
variable "peer_acceptor_region" {
  type = string
  default = null
}
variable "peer_tags" {
  type = map(string)
  default = {
    "Source" = "Managed by Terraform"
  }
}
variable "create_peer_routes" {
  type = bool
  default = true
}
variable "peer_subnets_association" {
  type = list(string)
  default = []
}
variable "peer_route_cidr_block" {
  type = list(string)
  default = []
}
variable "peer_owner_id" {
  type = string
  default = null
}
resource "aws_vpc_peering_connection" "create_peering" {
    count       = var.create_peering_connection ? 1 : 0
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_acceptor_vpc_id
  vpc_id        = var.peer_requester_vpc_id
  auto_accept   = var.peer_auto_accept_connection
  peer_region   = var.peer_acceptor_region
  tags          = var.peer_tags
}

data "aws_route_table" "add_peering_routes" {
    count = var.create_peering_connection && var.create_peer_routes && length(var.peer_subnets_association) > 0 ? length(var.peer_subnets_association) : 0
  subnet_id = var.peer_subnets_association[count.index]
}
resource "aws_route" "peering_route" {
    count = var.create_peering_connection && var.create_peer_routes && length(var.peer_subnets_association) > 0 ? length(var.peer_subnets_association) : 0
  route_table_id            = data.aws_route_table.add_peering_routes[count.index].id
  destination_cidr_block    = var.peer_route_cidr_block[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.create_peering.0.id
  depends_on                = [aws_vpc_peering_connection.create_peering]
}

output "peering_id" {
  value = join("",aws_vpc_peering_connection.create_peering.*.id)
}