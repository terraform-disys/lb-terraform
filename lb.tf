resource "azurerm_public_ip" "lb_pip" {
  name = "lb-pip"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  allocation_method   = "Static"
  domain_name_label =  azurerm_resource_group.lb_rg.name

}

resource "azurerm_lb" "loadbalancer" {
 name = "${var.prefix}-loadbalancer"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb_bap" {
  name = "${var.prefix}-backend-address-pool"
  loadbalancer_id = azurerm_lb.azurerm_lb.loadbalancer.id 
}

resource "azurerm_lb_nat_pool" "lb_nat_pool" {
  resource_group_name            = azurerm_resource_group.lb_rg.name
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "VMPool"
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 81
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe " "lb_probe" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "ssh-running-probe"
  port            = 22
}

resource "azurerm_lb_rule" "lb_rule" {
 loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
 
}

#Used for NATing outbound for vms 
resource "azurerm_lb_outbound_rule" "lb_ob_rule" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.loadbalancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool_id.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}

resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}