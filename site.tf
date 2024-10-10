resource "aws_customer_gateway" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value if var.vpn_type == "site_to_site" || var.vpn_type == "both"}
  bgp_asn    = 65000
  ip_address = each.value.customer_ip
  type       = each.value.type

  tags = {
    Name = each.key
  }
}

resource "aws_vpn_gateway" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value if var.vpn_type == "site_to_site" || var.vpn_type == "both"}
  vpc_id = each.value.vpc_id

  tags = {
    Name = each.key
  }
}

resource "aws_vpn_connection" "s2s" {
  for_each = { for key, value in var.site_to_site_vpn : key => value if var.vpn_type == "site_to_site" || var.vpn_type == "both"}
  vpn_gateway_id      = aws_vpn_gateway.s2s[each.key].id
  customer_gateway_id = aws_customer_gateway.s2s[each.key].id
  type                = each.value.type
  static_routes_only  = true
  tags = {
    Name = each.key
  }
}
