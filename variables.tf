variable "vpn_type" {
  description = "Select VPN type: client_endpoint or site_2_site"
  validation {
    error_message = "Value can only be: \"client_endpoint\" or \"site_2_site\"."
    condition = contains(["client_endpoint", "site_2_site"], var.vpn_type) 
  }
  
}

variable "client_endpoints" {
  description = "Configuration object indicating vpn endpoint setup."
  type = list(object({
      description : string
      client_cidr_block : string
      server_certificate_arn : string
      client_certificate_arn : string
      subnet_id : string
    }))
}