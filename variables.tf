variable "client_endpoint_vpn" {
  description = "Configuration object indicating vpn endpoint setup."
  default = {}
  type = map(object({
      client_cidr_block : string
      target_cidr_block : string
      server_certificate_arn : string
      client_certificate_arn : string
      subnet_id : string
    }))
}

variable "site_to_site_vpn" {
  description = "Configuration object indicating site to site vpn setup."
  default = {}
  type = map(object({
      customer_ip : string
      type : string
      vpc_id : string
      destination_cidr_block : string
      
    }))
}