output "vpn_connection_id" {
  description = "ID of the Site-to-Site VPN connection."
  value       = var.vpn_type == "site_to_site" ? aws_vpn_connection.s2s[0].id : null
}

output "transit_gateway_attachment_id" {
  description = "ID of the Transit Gateway VPN attachment, when Transit Gateway mode is used."
  value       = var.vpn_type == "site_to_site" && var.transit_gateway_id != null ? aws_vpn_connection.s2s[0].transit_gateway_attachment_id : null
}
