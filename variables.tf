variable "vpn_type" {
  description = "Select VPN type: client_endpoint, site_2_site or both"
  validation {
    error_message = "Value can only be: \"client_endpoint\", \"site_2_site\" or \"both\"."
    condition = contains(["client_endpoint", "site_2_site", "both"], var.vpn_type) 
  }
  
}

variable "client_endpoint_vpn" {
  description = "Configuration object indicating vpn endpoint setup."
  type = map(object({
      client_cidr_block : string
      target_cidr_block : string
      server_certificate_arn : string
      client_certificate_arn : string
      subnet_id : string
    }))
}

variable "site_to_site_vpn" {
  type = map(object({
      customer_ip : string
      type : string
      vpc_id : string
      
    }))
}