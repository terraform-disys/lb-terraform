# Resource-1: Create Public IP Address for Azure Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-pip"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.lb_rg.name

}

# Resource-2: Create Azure Load Balancer
resource "azurerm_lb" "loadbalancer" {
  name                = "${var.prefix}-loadbalancer"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "lb_bap" {
  name            = "${var.prefix}-backend-address-pool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

# # Resource-4: Create LB Rule
# resource "azurerm_lb_rule" "web_lb_rule" {
#   name                           = "lb-rule"
#   loadbalancer_id                = azurerm_lb.loadbalancer.id
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# # Resource-5: Create LB Probe
# resource "azurerm_lb_probe" "web_lb_probe" {
#   name                = "tcp-probe"
#   protocol            = "Tcp"
#   port                = 80
#   loadbalancer_id     = azurerm_lb.loadbalancer.id
#   #resource_group_name = azurerm_resource_group.lb_rg.name
# }

# Resource-6: Associate Network Interface and Standard Load Balancer

