locals {
  if_ddos_enabled = var.create_ddos_plan ? [{}] : []
}


resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = merge({ "Name" = format("%s", var.resource_group_name) }, var.resource_group_tags)
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
  address_space       = var.vnet_cidr
  location            = var.create_resource_group ? azurerm_resource_group.rg[0].location : var.resource_group_location
  dns_servers         = var.vnet_dns_servers

  dynamic "ddos_protection_plan" {
    for_each = local.if_ddos_enabled

    content {
      id     = azurerm_network_ddos_protection_plan.ddos[0].id
      enable = true
    }
  }
  tags = merge({ "Name" = format("%s", var.vnet_name) }, var.vnet_resource_tags)
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  count               = var.create_ddos_plan ? 1 : 0
  name                = var.ddos_plan_name
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name

  tags = merge({ "Name" = format("%s", var.vnet_name) }, var.ddos_resource_tags)
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets

  name                                           = lookup(each.value, "name")
  address_prefix                                 = lookup(each.value, "cidr")
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_network_policies", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_network_policies", false)
  resource_group_name                            = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
  service_endpoints                              = lookup(each.value, "service_endpoints")
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

resource "azurerm_subnet_route_table_association" "route_table_associations" {
  for_each       = var.route_tables_ids
  route_table_id = each.value
  subnet_id      = local.azurerm_subnets[each.key]
}
