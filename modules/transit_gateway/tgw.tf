
resource "aws_ec2_transit_gateway_vpc_attachment" "attach_transit_gateway" {
  count = var.attach_transit_gateway ? 1 : 0
  subnet_ids         = var.transit_gateway_subnetIds
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.transit_gateway_vpc_id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(var.transit_gateway_tags,{"Name" = "${var.transit_gateway_name}"})
}

resource "aws_route" "transit_tgw_route_attach" {
  count = var.attach_transit_gateway && var.update_route_table && length(var.route_table_id) > 0 ? length(var.route_table_id)  : 0
  route_table_id         = element(var.route_table_id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id         = var.transit_gateway_id

  timeouts {
    create = "5m"
  }
}