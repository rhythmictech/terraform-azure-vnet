# terraform-azure-vnet

[![CircleCI](https://circleci.com/gh/nlarzon/terraform-azure-vnet.svg?style=svg)](https://circleci.com/gh/nlarzon/terraform-azure-vnet)
[![Terraform Module Registry](https://img.shields.io/badge/Terraform%20Module%20Registry-0.9.3-green.svg)](https://registry.terraform.io/modules/nlarzon/vnet/azure/0.9.3)
![Terraform Version](https://img.shields.io/badge/Terraform-0.12.16-green.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Terraform Module to create Azure VNET and subnets using terraform 0.12

## Subnets

Subnet creation is using for_each in resources new in terraform 0.12.6

When creating subnets there is no way to "attach" them to a security group using this module. It is a conscious choice because of the deprication of that field.

Instead use [Subnet security group assosciation](https://www.terraform.io/docs/providers/azurerm/r/subnet_network_security_group_association.html) outside the module.

## DDOS Protection Plan

If you are using ddos protection plan option it creates an additional Azure resource group called "NetworkWatcherRG" this is a resource group created by Azure.
In addition terraform is unable to destroy the ddos protection plan so it has to be performed manually.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_ddos_protection_plan.ddos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.route_table_associations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ddos_plan"></a> [create\_ddos\_plan](#input\_create\_ddos\_plan) | Option to create an ddos plan | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Option to create a Azure resource group to use for VNET | `bool` | `true` | no |
| <a name="input_ddos_plan_name"></a> [ddos\_plan\_name](#input\_ddos\_plan\_name) | Name of the ddos plan | `string` | `"myDDOSplan"` | no |
| <a name="input_ddos_resource_tags"></a> [ddos\_resource\_tags](#input\_ddos\_resource\_tags) | Additional(optional) tags for ddos plan | `map(string)` | `{}` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location for resource group See. https://azure.microsoft.com/en-us/global-infrastructure/locations/ | `string` | `"North Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to use for the VNET, it is used in both cases even if the resource group is created | `string` | `"myRG"` | no |
| <a name="input_resource_group_tags"></a> [resource\_group\_tags](#input\_resource\_group\_tags) | Additional(optional) tags for resource group | `map(string)` | `{}` | no |
| <a name="input_route_tables_ids"></a> [route\_tables\_ids](#input\_route\_tables\_ids) | A map of subnet name to Route table ids | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet objects. name, cidr, and service\_endpoints supported | <pre>map(object({<br>    name                                  = string<br>    cidr                                  = string<br>    enforce_private_link_network_policies = bool<br>    service_endpoints                     = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | The CIDR block for VNET | `list` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_vnet_dns_servers"></a> [vnet\_dns\_servers](#input\_vnet\_dns\_servers) | Optional dns servers to use for VNET | `list` | `[]` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the VNET | `string` | `"myVNET"` | no |
| <a name="input_vnet_resource_tags"></a> [vnet\_resource\_tags](#input\_vnet\_resource\_tags) | Additional(optional) tags for VNET | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ddos_protection_plan"></a> [ddos\_protection\_plan](#output\_ddos\_protection\_plan) | Ddos protection plan |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | Resource group for VNET |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Created subnet resources |
| <a name="output_vnet"></a> [vnet](#output\_vnet) | VNET resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
