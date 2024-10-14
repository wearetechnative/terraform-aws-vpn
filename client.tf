resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  security_group_ids     = [aws_security_group.client_vpn[count.index].id]

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
    Name = var.name
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[count.index].id
  subnet_id              = var.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[count.index].id
  target_network_cidr    = var.target_cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[count.index].id
  destination_cidr_block = var.target_cidr_block
  target_vpc_subnet_id   = var.subnet_id
}

resource "aws_security_group" "client_vpn" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  name        = "Actiflow-ClientVPN-SG"
  description = "Access to AWS VPC for Actiflow personnel"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "ingress" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.client_cidr_block]
  security_group_id = aws_security_group.client_vpn[count.index].id
}

resource "aws_security_group_rule" "egress" {
  count = var.vpn_type == "client_endpoint" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.client_vpn[count.index].id
}
