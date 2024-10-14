resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  security_group_ids     = [aws_security_group.client_vpn.id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_certificate_arn
  }

  connection_log_options {
    enabled = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }
  tags = {
    Name = each.key
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  subnet_id              = each.value.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "client_vpn" {
  for_each               = toset(var.target_cidr_block)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  target_network_cidr    = each.key
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "client_vpn" {
  for_each               = toset(var.target_cidr_block)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  destination_cidr_block = each.value.target_cidr_block
  target_vpc_subnet_id   = each.value.subnet_id
}

resource "aws_security_group" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  name        = "Actiflow-ClientVPN-SG"
  description = "Access to AWS VPC for Actiflow personnel"
  vpc_id      = each.value.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["172.16.0.0/22"]
  security_group_id = aws_security_group.client_vpn.id
}

resource "aws_security_group_rule" "egress" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.client_vpn.id
}
