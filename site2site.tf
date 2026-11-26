resource "aws_customer_gateway" "s2s" {
  count      = var.vpn_type == "site_to_site" ? 1 : 0
  ip_address = var.customer_ip
  type       = var.tunnel_type
  bgp_asn    = var.bgp_asn
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_gateway" "s2s" {
  count  = var.vpn_type == "site_to_site" && var.transit_gateway_id == null ? 1 : 0
  vpc_id = var.s2s_vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_connection" "s2s" {
  count                    = var.vpn_type == "site_to_site" ? 1 : 0
  vpn_gateway_id           = var.transit_gateway_id == null ? aws_vpn_gateway.s2s[count.index].id : null
  transit_gateway_id       = var.transit_gateway_id
  customer_gateway_id      = aws_customer_gateway.s2s[count.index].id
  type                     = var.tunnel_type
  static_routes_only       = var.static_routes_only
  local_ipv4_network_cidr  = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr

  tunnel1_preshared_key                = var.tunnel1_config.preshared_key
  tunnel1_ike_versions                 = var.tunnel1_config.ike_versions
  tunnel1_phase1_encryption_algorithms = var.tunnel1_config.phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.tunnel1_config.phase1_integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = var.tunnel1_config.phase1_dh_group_numbers
  tunnel1_phase1_lifetime_seconds      = var.tunnel1_config.phase1_lifetime_seconds
  tunnel1_phase2_encryption_algorithms = var.tunnel1_config.phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.tunnel1_config.phase2_integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = var.tunnel1_config.phase2_dh_group_numbers
  tunnel1_phase2_lifetime_seconds      = var.tunnel1_config.phase2_lifetime_seconds
  tunnel1_dpd_timeout_action           = var.tunnel1_config.dpd_timeout_action
  tunnel1_dpd_timeout_seconds          = var.tunnel1_config.dpd_timeout_seconds
  tunnel1_startup_action               = var.tunnel1_config.startup_action
  tunnel1_inside_cidr                  = var.tunnel1_config.inside_cidr

  tunnel2_preshared_key                = var.tunnel2_config.preshared_key
  tunnel2_ike_versions                 = var.tunnel2_config.ike_versions
  tunnel2_phase1_encryption_algorithms = var.tunnel2_config.phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel2_config.phase1_integrity_algorithms
  tunnel2_phase1_dh_group_numbers      = var.tunnel2_config.phase1_dh_group_numbers
  tunnel2_phase1_lifetime_seconds      = var.tunnel2_config.phase1_lifetime_seconds
  tunnel2_phase2_encryption_algorithms = var.tunnel2_config.phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel2_config.phase2_integrity_algorithms
  tunnel2_phase2_dh_group_numbers      = var.tunnel2_config.phase2_dh_group_numbers
  tunnel2_phase2_lifetime_seconds      = var.tunnel2_config.phase2_lifetime_seconds
  tunnel2_dpd_timeout_action           = var.tunnel2_config.dpd_timeout_action
  tunnel2_dpd_timeout_seconds          = var.tunnel2_config.dpd_timeout_seconds
  tunnel2_startup_action               = var.tunnel2_config.startup_action
  tunnel2_inside_cidr                  = var.tunnel2_config.inside_cidr
  tags = {
    Name = var.name
  }

  # Tunnel settings are coordinated with the remote VPN administrator and may
  # be changed outside Terraform. In particular, Azure uses one shared key for
  # both AWS tunnels. Do not reset those settings during unrelated applies.
  lifecycle {
    ignore_changes = [
      tunnel1_preshared_key,
      tunnel1_ike_versions,
      tunnel1_phase1_dh_group_numbers,
      tunnel1_phase1_encryption_algorithms,
      tunnel1_phase1_integrity_algorithms,
      tunnel1_phase1_lifetime_seconds,
      tunnel1_phase2_dh_group_numbers,
      tunnel1_phase2_encryption_algorithms,
      tunnel1_phase2_integrity_algorithms,
      tunnel1_phase2_lifetime_seconds,
      tunnel1_rekey_fuzz_percentage,
      tunnel1_rekey_margin_time_seconds,
      tunnel1_replay_window_size,
      tunnel1_startup_action,
      tunnel2_preshared_key,
      tunnel2_ike_versions,
      tunnel2_phase1_dh_group_numbers,
      tunnel2_phase1_encryption_algorithms,
      tunnel2_phase1_integrity_algorithms,
      tunnel2_phase1_lifetime_seconds,
      tunnel2_phase2_dh_group_numbers,
      tunnel2_phase2_encryption_algorithms,
      tunnel2_phase2_integrity_algorithms,
      tunnel2_phase2_lifetime_seconds,
      tunnel2_rekey_fuzz_percentage,
      tunnel2_rekey_margin_time_seconds,
      tunnel2_replay_window_size,
      tunnel2_startup_action,
    ]
  }
}

resource "aws_vpn_connection_route" "s2s" {
  count                  = var.vpn_type == "site_to_site" && var.transit_gateway_id == null && var.static_routes_only ? length(var.destination_cidr_block) : 0
  destination_cidr_block = var.destination_cidr_block[count.index]
  vpn_connection_id      = aws_vpn_connection.s2s[0].id
}

data "aws_route_table" "s2s" {
  count  = var.vpn_type == "site_to_site" && var.transit_gateway_id == null ? 1 : 0
  vpc_id = var.s2s_vpc_id
  filter {
    name   = "association.main"
    values = [true]
  }
}

resource "aws_route" "route" {
  count                  = var.vpn_type == "site_to_site" && var.transit_gateway_id == null ? length(var.destination_cidr_block) : 0
  route_table_id         = data.aws_route_table.s2s[0].id
  destination_cidr_block = var.destination_cidr_block[count.index]
  gateway_id             = aws_vpn_gateway.s2s[0].id
}

data "aws_route_tables" "s2s" {
  count  = var.vpn_type == "site_to_site" && var.transit_gateway_id == null ? 1 : 0
  vpc_id = var.s2s_vpc_id
  filter {
    name   = "association.main"
    values = ["false"]
  }
}


resource "aws_route" "subnet_routes" {
  count                  = length(local.s2s_route_entries)
  route_table_id         = local.s2s_route_entries[count.index].route_table_id
  destination_cidr_block = local.s2s_route_entries[count.index].destination_cidr_block
  gateway_id             = aws_vpn_gateway.s2s[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "s2s" {
  count = var.vpn_type == "site_to_site" && var.transit_gateway_id != null && var.transit_gateway_route_table_id != null ? 1 : 0

  transit_gateway_attachment_id  = aws_vpn_connection.s2s[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "s2s" {
  count = var.vpn_type == "site_to_site" && var.transit_gateway_id != null && var.transit_gateway_route_table_id != null && !var.static_routes_only && var.enable_transit_gateway_route_propagation ? 1 : 0

  transit_gateway_attachment_id  = aws_vpn_connection.s2s[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id

  depends_on = [aws_ec2_transit_gateway_route_table_association.s2s]
}

resource "aws_ec2_transit_gateway_route" "s2s" {
  count = var.vpn_type == "site_to_site" && var.transit_gateway_id != null && var.transit_gateway_route_table_id != null && var.static_routes_only ? length(var.destination_cidr_block) : 0

  destination_cidr_block         = var.destination_cidr_block[count.index]
  transit_gateway_attachment_id  = aws_vpn_connection.s2s[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id

  depends_on = [aws_ec2_transit_gateway_route_table_association.s2s]
}
