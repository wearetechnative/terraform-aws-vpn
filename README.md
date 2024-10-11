> START INSTRUCTION FOR TECHNATIVE ENGINEERS

# terraform-aws-module-template

Template for creating a new TerraForm AWS Module. For TechNative Engineers.

## Instructions

### Your Module Name

Think hard and come up with the shortest descriptive name for your module.
Look at competition in the [terraform
registry](https://registry.terraform.io/).

Your module name should be max. three words seperated by dashes. E.g.

- html-form-action
- new-account-notifier
- budget-alarms
- fix-missing-tags

### Setup Github Project

1. Click the template button on the top right...
1. Name github project `terraform-aws-[your-module-name]`
1. Make project private untill ready for publication
1. Add a description in the `About` section (top right)
1. Add tags: `terraform`, `terraform-module`, `aws` and more tags relevant to your project: e.g. `s3`, `lambda`, `sso`, etc..
1. Install `pre-commit`

### Develop your module

1. Develop your module
1. Try to use the [best practices for TerraForm
   development](https://www.terraform-best-practices.com/) and [TerraForm AWS
   Development](https://github.com/ozbillwang/terraform-best-practices).

## Finish project documentation

1. Set well written title
2. Add one or more shields
3. Start readme with a short and complete as possible module description. This
   is the part where you sell your module.
4. Complete README with well written documentation. Try to think as a someone
   with three months of Terraform experience.
5. Check if pre-commit correctly generates the standard Terraform documentation.

## Publish module

If your module is in a state that it could be useful for others and ready for
publication, you can publish a first version.

1. Create a [Github
   Release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
2. Publish in the TerraForm Registry under the Technative Namespace (the GitHub
   Repo must be in the TechNative Organization)

---

> END INSTRUCTION FOR TECHNATIVE ENGINEERS


# Terraform AWS [Module Name] ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

<!-- SHIELDS -->

This module implements ...

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

...

## Usage

To use this module ...

```hcl
module "vpn" {
  source = "git@github.com:wearetechnative/terraform-aws-vpn.git"
  
  client_endpoint_vpn = {
    john = {      ### created resources will get this name in console
      client_cidr_block = "10.5.0.0/16"
      target_cidr_block = "0.0.0.0/0"
      server_certificate_arn = "arn:aws:acm:eu-central-1:123123123123:certificate/02f386fe-b591-4901-8e33-5c0b40e15ffe"
      client_certificate_arn = "arn:aws:acm:eu-central-1:123123123123:certificate/b5a0b0b8-65d0-49ff-9f4c-b53ef7e82edb"
      subnet_id = "subnet-02d09b7d1dd3d0e31"
    }  
  }

  site_to_site_vpn = {
    office = {
      customer_ip = "123.123.123.123"      ### public ip of your device (ISP)
      type = "ipsec.1"
      vpc_id = "vpc-09fc27ba33099891e"
      
    }
  }
}
```

### Add route to VPC main route table where the virtual gateway is located

Destination: your local subnet
Target is the virtual gateway id

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
