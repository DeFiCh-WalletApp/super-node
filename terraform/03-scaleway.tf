
data "azurerm_key_vault_secret" "docker_registry" {
  name         = "defichain-container-registry"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "docker_registry_username" {
  name         = "defichain-container-registry-username"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "docker_registry_password" {
  name         = "defichain-container-registry-password"
  key_vault_id = var.key_vault_id
}


data "template_file" "cloud_init" {
  template   = file("${path.root}/cloud-init/cloud-init.yml")

  vars = {
    docker_registry      = data.azurerm_key_vault_secret.docker_registry.value
    docker_registry_username = data.azurerm_key_vault_secret.docker_registry_username.value
    docker_registry_password = data.azurerm_key_vault_secret.docker_registry_password.value
  }
}

module "chain_scaleway_network_nodes" {
  source = "./libs/scaleway-node"

  node_count = 1
  name = "defichain-supernode"
  prefix = var.prefix
  environment = var.environment
  cloud_init = data.template_file.cloud_init.rendered
  
  ssh_key_file = "${path.root}/secrets/scaleway.key"
  
  dns_zone = var.dns_zone
  dns_zone_resource_group = var.dns_zone_resource_group
  
  resource_group = azurerm_resource_group.rg.name
  traffic_manager = module.traffic_manager.name
  network="testnet"
}
