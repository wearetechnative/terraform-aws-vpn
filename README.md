# Terraform AWS vpn ![](https://img.shields.io/github/actions/workflow/status/wearetechnative/terraform-aws-vpn/lint.yaml?branch=main&style=plastic&label=lint) ![](https://img.shields.io/github/actions/workflow/status/wearetechnative/terraform-aws-vpn/security-scan.yaml?branch=main&style=plastic&label=security)

<!-- SHIELDS -->

This module implements a secure site-2-site VPN connection.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.


## Transit Gateway Site-to-Site VPN with BGP

```hcl
module "vpn" {
  source = "git@github.com:wearetechnative/terraform-aws-vpn.git"

  vpn_type   = "site_to_site"
  name       = "office"
  customer_ip = "203.0.113.10"
  bgp_asn     = 65010

  transit_gateway_id             = module.transit_gateway.id
  transit_gateway_route_table_id = module.transit_gateway.route_table_id

  static_routes_only                     = false
  enable_transit_gateway_route_propagation = true
}
```

With BGP enabled, the customer gateway advertises its network routes to the
Transit Gateway. The Transit Gateway advertises the routes from its associated
route table back to the customer gateway. VPC subnet route tables still need
routes for the remote network with the Transit Gateway as their target.

The existing virtual private gateway mode remains the default. When
`transit_gateway_id` is omitted, the module creates a VPN gateway for
`s2s_vpc_id`; `static_routes_only` defaults to `true` for backward
compatibility.

## Transit Gateway Site-to-Site VPN with static routes

Use static routing when the remote gateway does not support BGP. Each CIDR in
`destination_cidr_block` is added to the Transit Gateway route table with the
VPN attachment as its target.

```hcl
module "vpn" {
  source = "git@github.com:wearetechnative/terraform-aws-vpn.git"

  vpn_type    = "site_to_site"
  name        = "office"
  customer_ip = "203.0.113.10"
  bgp_asn     = 65000

  transit_gateway_id             = module.transit_gateway.id
  transit_gateway_route_table_id = module.transit_gateway.route_table_id

  static_routes_only = true
  destination_cidr_block = [
    "10.0.0.0/21",
  ]
}
```

VPC subnet route tables still need matching routes with the Transit Gateway as
their target. `enable_transit_gateway_route_propagation` applies only to BGP
VPNs and is ignored for static TGW VPNs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.66.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_ec2_client_vpn_authorization_rule.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_ec2_transit_gateway_route.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_route.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.subnet_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpn_connection.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |
| [aws_vpn_gateway.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_route_table.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN) | `number` | `null` | no |
| <a name="input_client_certificate_arn"></a> [client\_certificate\_arn](#input\_client\_certificate\_arn) | The ARN of the ACM client certificate | `string` | `null` | no |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. | `string` | `null` | no |
| <a name="input_customer_ip"></a> [customer\_ip](#input\_customer\_ip) | The IPv4 address for the customer gateway device's outside interface. | `string` | `null` | no |
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | Remote network CIDRs. Used for static VPN routes; ignored when BGP is enabled. | `list(string)` | `[]` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. If no DNS server is specified, the DNS address of the connecting device is used. | `list(string)` | `null` | no |
| <a name="input_enable_transit_gateway_route_propagation"></a> [enable\_transit\_gateway\_route\_propagation](#input\_enable\_transit\_gateway\_route\_propagation) | Propagate routes learned by the VPN attachment into the Transit Gateway route table. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Naming for the resources in the console | `string` | n/a | yes |
| <a name="input_s2s_vpc_id"></a> [s2s\_vpc\_id](#input\_s2s\_vpc\_id) | The VPC ID to create the gateway in | `string` | `null` | no |
| <a name="input_server_certificate_arn"></a> [server\_certificate\_arn](#input\_server\_certificate\_arn) | The ARN of the ACM server certificate | `string` | `null` | no |
| <a name="input_static_routes_only"></a> [static\_routes\_only](#input\_static\_routes\_only) | Use static VPN routes instead of BGP. Defaults to true for backward compatibility. | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to associate with the Client VPN endpoint | `string` | `null` | no |
| <a name="input_target_cidr_block"></a> [target\_cidr\_block](#input\_target\_cidr\_block) | The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies. | `string` | `null` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit Gateway ID for a Transit Gateway Site-to-Site VPN. When unset, the VPN uses a virtual private gateway attached to s2s\_vpc\_id. | `string` | `null` | no |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | Transit Gateway route table to associate with the VPN attachment. | `string` | `null` | no |
| <a name="input_tunnel_type"></a> [tunnel\_type](#input\_tunnel\_type) | The type of customer gateway. The only type AWS supports at this time is "ipsec.1" | `string` | `"ipsec.1"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to associate with the Client VPN endpoint. | `string` | `null` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | Select VPN type: client\_endpoint or site\_to\_site | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_transit_gateway_attachment_id"></a> [transit\_gateway\_attachment\_id](#output\_transit\_gateway\_attachment\_id) | ID of the Transit Gateway VPN attachment, when Transit Gateway mode is used. |
| <a name="output_vpn_connection_id"></a> [vpn\_connection\_id](#output\_vpn\_connection\_id) | ID of the Site-to-Site VPN connection. |
<!-- END_TF_DOCS -->
