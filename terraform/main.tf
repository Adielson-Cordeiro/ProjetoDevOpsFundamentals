terraform {
    required_version = "~> 1.11.0"
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 3.0"
      }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "pj_rg" {
    location  = "brazilsouth"
    name      = "rg-projetodevops-001"

    tags = {
      Ambiente    = "Desenvolvimento"
      Responsavel = "Adielson Nascimento"
      Setor       = "Marketing"
    }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-vms"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.pj_rg.location
  resource_group_name = azurerm_resource_group.pj_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                  = "subnet-vms"
  resource_group_name   = azurerm_resource_group.pj_rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.vm_base_name}-nic-${count.index}"
  location            = azurerm_resource_group.pj_rg.location
  resource_group_name = azurerm_resource_group.pj_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.vm_count
  name                            = "${var.vm_base_name}-${count.index}"
  resource_group_name             = azurerm_resource_group.pj_rg.name
  location                        = azurerm_resource_group.pj_rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]

  tags = azurerm_resource_group.pj_rg.tags

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }

  source_image_reference {
    publisher   = "Canonical"
    offer       = "0001-com-ubuntu-server-jammy"
    sku         = "22_04-lts-gen2"
    version     = "latest"
  }
}

resource "random_id" "suffix" {
  byte_length                     = 4
}

resource "azurerm_mssql_server" "sql_server" {
  name                            = "${var.sql_server_name}-${random_id.suffix.hex}"
  resource_group_name             = azurerm_resource_group.pj_rg.name
  location                        = azurerm_resource_group.pj_rg.location
  version                         = "12.0"

  administrator_login             = var.slq_admin_username
  administrator_login_password    = var.slq_admin_password

  minimum_tls_version             = "1.2"
  public_network_access_enabled   = true

  tags                            = azurerm_resource_group.pj_rg.tags

}

resource "azurerm_mssql_database" "sql_database" {
  name            = var.sql_database_name
  server_id       = azurerm_mssql_server.sql_server.id
  collation       = "SQL_Latin1_General_CP1_CI_AS"
  sku_name        = "S0"
  max_size_gb     = 50

  tags            = azurerm_resource_group.pj_rg.tags

}

resource "azurerm_mssql_firewall_rule" "example" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}