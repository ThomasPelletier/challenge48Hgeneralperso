output "public_ip_instance1" {
  value = azurerm_public_ip.publicip_instance1.ip_address
}

output "dns_instance_1" {
  value = azurerm_public_ip.publicip_instance2.ip_address
}