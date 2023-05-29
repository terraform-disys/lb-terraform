# Resource-2: Create Network Interface
resource "azurerm_network_interface" "lb_nic" {
  count               = 3
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  ip_configuration {
    name                          = "IPConfig${count.index}"
    subnet_id                     = azurerm_subnet.lb_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "test" {
  count = 3
  name                 = "${var.prefix}-mdisk-${count.index}"
  location             = azurerm_resource_group.lb_rg.location
  resource_group_name  = azurerm_resource_group.lb_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

resource "azurerm_availability_set" "lb_avset" {
  name                         = "${var.prefix}-avset"
  location                     = azurerm_resource_group.lb_rg.location
  resource_group_name          = azurerm_resource_group.lb_rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 3
  managed                      = true
}

resource "azurerm_virtual_machine" "lb_vms" {
  count                 = 3
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.lb_rg.location
  availability_set_id = azurerm_availability_set.lb_avset.id
  resource_group_name   = azurerm_resource_group.lb_rg.name
  network_interface_ids = [azurerm_network_interface.lb_nic[count.index].id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  # storage_data_disk {

  # }

  storage_data_disk {
     name              = "datadisk_new_${count.index}"
     managed_disk_type = "Standard_LRS"
     create_option     = "Empty"
     lun               = 0
     disk_size_gb      = "1"
   }

   storage_data_disk {
     name            = element(azurerm_managed_disk.test.*.name, count.index)
     managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
     create_option   = "Attach"
     lun             = 1
     disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
   }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}