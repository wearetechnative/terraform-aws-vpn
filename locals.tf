locals {
  s2s_route_entries = var.vpn_type == "site_to_site" ? flatten([
    for route_table_id in data.aws_route_tables.s2s[0].ids : [
      for cidr in var.destination_cidr_block : {
        route_table_id         = route_table_id
        destination_cidr_block = cidr
      }
    ]
  ]) : []
}
