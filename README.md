# Terraform AWS vpn ![](https://img.shields.io/github/actions/workflow/status/wearetechnative/terraform-aws-vpn/tflint.yaml?style=plastic)

<!-- SHIELDS -->

This module implements a secure site-2-site VPN connection.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.


## Usage

To use this module ...

```hcl
module "vpn" {
  source = "git@github.com:wearetechnative/terraform-aws-vpn.git"
  
  client_endpoint_vpn = {
    john = {                                 ### created resources will get this name in console
      client_cidr_block = "10.5.0.0/16"
      target_cidr_block = "0.0.0.0/0"        ### You can give access to a smaller ip pool if you'd like
      server_certificate_arn = "arn:aws:acm:eu-central-1:123123123123:certificate/02f386fe-b591-4901-8e33-5c0b40e15ffe"
      client_certificate_arn = "arn:aws:acm:eu-central-1:123123123123:certificate/b5a0b0b8-65d0-49ff-9f4c-b53ef7e82edb"
      vpc_id = "vpc-09fc27ba33099891e"
      subnet_id = "subnet-02d09b7d1dd3d0e31" ### Subnet to allow access to (use routes to allow access to multiple subnets)
    }  
  }

  site_to_site_vpn = {
    office = {
      customer_ip = "123.123.123.123"      ### public ip of your device (ISP)
      type = "ipsec.1"
      vpc_id = "vpc-09fc27ba33099891e"
      destination_cidr_block = '10.0.0.0/24"
      
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| [aws_route.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.client_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpn_connection.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |
| [aws_vpn_gateway.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_route_table.s2s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN) | `number` | `null` | no |
| <a name="input_client_certificate_arn"></a> [client\_certificate\_arn](#input\_client\_certificate\_arn) | The ARN of the ACM client certificate | `string` | `null` | no |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. | `string` | `null` | no |
| <a name="input_customer_ip"></a> [customer\_ip](#input\_customer\_ip) | The IPv4 address for the customer gateway device's outside interface. | `string` | `null` | no |
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | The CIDR block associated with the local subnet of the customer network | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Naming for the resources in the console | `string` | n/a | yes |
| <a name="input_s2s_vpc_id"></a> [s2s\_vpc\_id](#input\_s2s\_vpc\_id) | The VPC ID to create the gateway in | `string` | `null` | no |
| <a name="input_server_certificate_arn"></a> [server\_certificate\_arn](#input\_server\_certificate\_arn) | The ARN of the ACM server certificate | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to associate with the Client VPN endpoint | `string` | `null` | no |
| <a name="input_target_cidr_block"></a> [target\_cidr\_block](#input\_target\_cidr\_block) | The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies. | `string` | `null` | no |
| <a name="input_tunnel_type"></a> [tunnel\_type](#input\_tunnel\_type) | The type of customer gateway. The only type AWS supports at this time is "ipsec.1" | `string` | `"ipsec.1"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to associate with the Client VPN endpoint. | `string` | `null` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | Select VPN type: client\_endpoint or site\_to\_site | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
