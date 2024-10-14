resource "aws_customer_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  ip_address = var.customer_ip
  type       = var.tunnel_type
  bgp_asn = var.bgp_asn
}

resource "aws_vpn_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id   = var.s2s_vpc_id
}

resource "aws_vpn_connection" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.s2s[count.index].id
  customer_gateway_id = aws_customer_gateway.s2s[count.index].id
  type                = var.tunnel_type
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  destination_cidr_block = var.destination_cidr_block
  vpn_connection_id      = aws_vpn_connection.s2s[count.index].id
}

data "aws_route_table" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id   = var.s2s_vpc_id
  filter {
    name = "association.main"
    values = [true]
  }
}

resource "aws_route" "route" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  route_table_id         = data.aws_route_table.s2s[count.index].id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_vpn_gateway.s2s[count.index].id
}
