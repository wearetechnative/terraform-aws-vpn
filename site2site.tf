resource "aws_customer_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  ip_address = var.customer_ip
  type       = var.tunnel_type
  bgp_asn = var.bgp_asn
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_gateway" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id   = var.s2s_vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_connection" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.s2s[count.index].id
  customer_gateway_id = aws_customer_gateway.s2s[count.index].id
  type                = var.tunnel_type
  static_routes_only  = true
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_connection_route" "s2s" {
  count = var.vpn_type == "site_to_site" ? length(var.destination_cidr_block) : 0
  destination_cidr_block = var.destination_cidr_block[count.index]
  vpn_connection_id      = aws_vpn_connection.s2s[0].id
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
  count = var.vpn_type == "site_to_site" ? length(var.destination_cidr_block) : 0
  route_table_id         = data.aws_route_table.s2s[0].id
  destination_cidr_block = var.destination_cidr_block[count.index]
  gateway_id             = aws_vpn_gateway.s2s[0].id
}

data "aws_route_tables" "s2s" {
  count = var.vpn_type == "site_to_site" ? 1 : 0
  vpc_id = var.s2s_vpc_id
  filter {
    name   = "association.main"
    values = ["false"]
  }
}


resource "aws_route" "subnet_routes" {
  count = length(local.s2s_route_entries)
  route_table_id         = local.s2s_route_entries[count.index].route_table_id
  destination_cidr_block = local.s2s_route_entries[count.index].destination_cidr_block
  gateway_id             = aws_vpn_gateway.s2s[0].id
}
