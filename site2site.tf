resource "aws_customer_gateway" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value }
  bgp_asn    = 65000
  ip_address = each.value.customer_ip
  type       = each.value.type

  tags = {
    Name = each.key
  }
}

resource "aws_vpn_gateway" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value } 
  vpc_id = each.value.vpc_id

  tags = {
    Name = each.key
  }
}

resource "aws_vpn_connection" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value }
  vpn_gateway_id      = aws_vpn_gateway.s2s[each.key].id
  customer_gateway_id = aws_customer_gateway.s2s[each.key].id
  type                = each.value.type
  static_routes_only  = true
  tags = {
    Name = each.key
  }
}

resource "aws_vpn_connection_route" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value }
  destination_cidr_block = each.value.destination_cidr_block
  vpn_connection_id      = aws_vpn_connection.main.id
}
