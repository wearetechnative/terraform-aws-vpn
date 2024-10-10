resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  for_each = { for key, value in var.client_endpoint_vpn : key => value if var.client_endpoint_vpn != null }
  server_certificate_arn = each.value.server_certificate_arn
  client_cidr_block      = each.value.client_cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = each.value.client_certificate_arn
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }
  tags = {
    Name = each.key
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn" {
  for_each = { for key, value in var.client_endpoint_vpn : key => value if var.client_endpoint_vpn != null }
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[each.key].id
  subnet_id              = each.value.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "client_vpn" {
  for_each = { for key, value in var.client_endpoint_vpn : key => value if var.client_endpoint_vpn != null }
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[each.key].id
  target_network_cidr    = each.value.target_cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "client_vpn" {
  for_each = { for key, value in var.client_endpoint_vpn : key => value if var.client_endpoint_vpn != null }
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[each.key].id
  destination_cidr_block = each.value.target_cidr_block
  target_vpc_subnet_id   = each.value.subnet_id
}
