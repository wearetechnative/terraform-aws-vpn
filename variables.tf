variable "vpn_type" {
  description = "Select VPN type: client_endpoint or site_to_site"
  type        = string
  validation {
    error_message = "Value can only be: \"client_endpoint\", \"site_to_site\"."
    condition     = contains(["client_endpoint", "site_to_site"], var.vpn_type)
  }
}

variable "name" {
  description = "Naming for the resources in the console"
  type        = string
}

## Client endpoint

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses."
  default     = null
  type        = string
}

variable "target_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies."
  default     = null
  type        = string
}

variable "server_certificate_arn" {
  description = "The ARN of the ACM server certificate"
  default     = null
  type        = string
}

variable "client_certificate_arn" {
  description = "The ARN of the ACM client certificate"
  default     = null
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the Client VPN endpoint."
  default     = null
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the Client VPN endpoint"
  default     = null
  type        = string
}

## Site to site

variable "customer_ip" {
  description = "The IPv4 address for the customer gateway device's outside interface."
  default     = null
  type        = string
}

variable "bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
  default     = null
  type        = number
}

variable "tunnel_type" {
  description = "The type of customer gateway. The only type AWS supports at this time is \"ipsec.1\""
  type        = string
  default     = "ipsec.1"
}

variable "s2s_vpc_id" {
  description = "The VPC ID to create the gateway in"
  default     = null
  type        = string
}

variable "destination_cidr_block" {
  description = "Remote network CIDRs. Used for static VPN routes; ignored when BGP is enabled."
  default     = []
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID for a Transit Gateway Site-to-Site VPN. When unset, the VPN uses a virtual private gateway attached to s2s_vpc_id."
  type        = string
  default     = null
}

variable "transit_gateway_route_table_id" {
  description = "Transit Gateway route table to associate with the VPN attachment."
  type        = string
  default     = null
}

variable "static_routes_only" {
  description = "Use static VPN routes instead of BGP. Defaults to true for backward compatibility."
  type        = bool
  default     = true
}

variable "enable_transit_gateway_route_propagation" {
  description = "Propagate routes learned by the VPN attachment into the Transit Gateway route table."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = " Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. If no DNS server is specified, the DNS address of the connecting device is used."
  type        = list(string)
  default     = null
}
