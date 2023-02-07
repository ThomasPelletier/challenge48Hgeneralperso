#----------------------------------------------------------------------------------#
# Resource group                                                                   #
#----------------------------------------------------------------------------------#

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location

  tags = {
    managed_by = "terraform"
  }
}

#----------------------------------------------------------------------------------#
# Networks                                                                         #
#----------------------------------------------------------------------------------#

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_space]
}

resource "azurerm_network_security_group" "nsg" {
  name                = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "first"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "second"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "third"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "publicip_instance1" {
  name                = "publicip1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "publicip_instance2" {
  name                = "publicip2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#----------------------------------------------------------------------------------#
# HUB Database                                                                     #
#----------------------------------------------------------------------------------#

resource "azurerm_mysql_flexible_server" "hub" {
  name                   = "hub-all-commerce"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "hubadmin"
  administrator_password = "H@Sh1CoR3!-MUCGqJRyIR"
  backup_retention_days  = 1
  sku_name               = "B_Standard_B2s"
  version                = "8.0.21"
  zone                   = 1
}

resource "azurerm_mysql_flexible_server_firewall_rule" "hub" {
  name                = "all"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.hub.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.hub.name
  value               = "OFF"
}

resource "null_resource" "create-database-script" {

  depends_on = [
    azurerm_mysql_flexible_server.hub,
    azurerm_mysql_flexible_server_firewall_rule.hub,
    azurerm_mysql_flexible_server_configuration.require_secure_transport
  ]
  
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "mysql -u ${azurerm_mysql_flexible_server.hub.administrator_login} -h ${azurerm_mysql_flexible_server.hub.fqdn} -p'${azurerm_mysql_flexible_server.hub.administrator_password}' < ../../mysql/setupHub.sql"
  }

}

#----------------------------------------------------------------------------------#
# Instances                                                                        #
#----------------------------------------------------------------------------------#


resource "azurerm_network_interface" "nic_instance1" {
  name                = "nicinstance1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nicinstance1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_instance1.id
  }
}

resource "azurerm_network_interface" "nic_instance2" {
  name                = "nicinstance2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nicinstance2"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_instance2.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic1-nsg" {
  network_interface_id      = azurerm_network_interface.nic_instance1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nic2-nsg" {
  network_interface_id      = azurerm_network_interface.nic_instance2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "instance1" {
  name                  = "instance1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_instance1.id]
  size                  = var.vm_size
  admin_username        = "adminuser"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  admin_ssh_key {
    username = "adminuser"
    public_key = file("../id_rsa.pub")
  }
}

resource "azurerm_linux_virtual_machine" "instance2" {
  name                  = "instance2"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_instance2.id]
  size                  = var.vm_size
  admin_username        = "adminuser"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  admin_ssh_key {
    username = "adminuser"
    public_key = file("../id_rsa.pub")
  }
}

#----------------------------------------------------------------------------------#
# DNS                                                                              #
#----------------------------------------------------------------------------------#

resource "ovh_domain_zone_record" "instance1" {
  zone      = "adminadmin.fr"
  subdomain = "instance1"
  fieldtype = "A"
  ttl       = "60"
  target    = "${azurerm_public_ip.publicip_instance1.ip_address}"
}

resource "ovh_domain_zone_record" "instance2" {
  zone      = "adminadmin.fr"
  subdomain = "instance2"
  fieldtype = "A"
  ttl       = "60"
  target    = "${azurerm_public_ip.publicip_instance2.ip_address}"
}

#----------------------------------------------------------------------------------#
# Deploy                                                                           #
#----------------------------------------------------------------------------------#

resource "null_resource" "run-ansible-script" {

  depends_on = [
    azurerm_linux_virtual_machine.instance1,
    azurerm_linux_virtual_machine.instance2,
    azurerm_mysql_flexible_server.hub
  ]
  
  triggers = {
    always_run = "${timestamp()}"
  }

  # infra

  provisioner "local-exec" {
    command = "sed -i '5 s/.*/${azurerm_public_ip.publicip_instance1.ip_address}/g'  ../ansible/hosts"
  }
  provisioner "local-exec" {
    command = "sed -i '6 s/.*/${azurerm_public_ip.publicip_instance2.ip_address}/g'  ../ansible/hosts"
  }

  # run

  provisioner "local-exec" {
    command     = "cd ../ansible/ && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook host.yml -i ./hosts"
  }

}