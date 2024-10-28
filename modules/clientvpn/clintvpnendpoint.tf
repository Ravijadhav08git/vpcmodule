resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
  count = var.create_client_vpn_endpoint ? 1 : 0
  description            = "Safe VPN clent"
  server_certificate_arn =  var.vpn_server_certificate_arn
  client_cidr_block      =  var.vpn_client_cidr_block
  split_tunnel           = "true"
  tags = {
      "Name" = var.vpnClientName
  }

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.vpc_user_certificate_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = "VPNConnection"
    cloudwatch_log_stream = "ConnectionLogs"
  }
}


resource "aws_ec2_client_vpn_network_association" "vpn_network_association" {
  count = var.create_client_vpn_endpoint && length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  subnet_id      = element(var.subnet_ids,count.index)
  security_groups        = var.security_groups_vpn
}

resource "aws_ec2_client_vpn_authorization_rule" "client_vpn_authorization_rule" {
  count = var.create_client_vpn_endpoint ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}