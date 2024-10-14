variable "vpn_type" {
  description = "Select VPN type: client_endpoint or site_2_site"
  validation {
    error_message = "Value can only be: \"client_endpoint\", \"site_2_site\"."
    condition = contains(["client_endpoint", "site_2_site"], var.vpn_type) 
  }
  
}

variable "client_cidr_block" {
  type = string
}

variable "target_cidr_block" {
  type = string
}
    
variable "server_certificate_arn" {
  type = string
}  

variable "client_certificate_arn" {
  type = string
}

variable "vpc_id" {
  type = string
} 

variable "subnet_id" {
  type = string
}

    
variable "s2s_customer_ip" {
  type = string
}  

variable "tunnel_type" {
  
}

variable "s2s_vpc_id" {
  type = string
}

variable "destination_cidr_block" {
  type = list
}

