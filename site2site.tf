resource "aws_customer_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  ip_address = var.s2s_customer_ip
  type       = var.tunnel_type

  # tags = {
  #   Name = each.key
  # }
}

resource "aws_vpn_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id   = each.value.vpc_id

  # tags = {
  #   Name = each.key
  # }
}

resource "aws_vpn_connection" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.s2s.id
  customer_gateway_id = aws_customer_gateway.s2s.id
  type                = var.tunnel_type
  static_routes_only  = true
  # tags = {
  #   Name = each.key
  # }
}

resource "aws_vpn_connection_route" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  destination_cidr_block = var.destination_cidr_block
  vpn_connection_id      = aws_vpn_connection.s2s.id
}

data "aws_route_table" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id   = var.vpc_id
  filter {
    name = "association.main"
    values = [true]
  }
}

resource "aws_route" "route" {
  for_each               = toset(var.destination_cidr_block)
  route_table_id         = data.aws_route_table.s2s.id
  destination_cidr_block = each.key
  gateway_id             = aws_vpn_gateway.s2s.id
}
