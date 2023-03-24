data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "k8s_playground" {
  name     = "k8s-playground"
  location = "West Europe"
}

resource "azurerm_key_vault" "k8s_keyvault" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.k8s_playground.location
  resource_group_name         = azurerm_resource_group.k8s_playground.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "my_secret" {
  name         = "secret-name"
  value        = "mysecretvalue"
  key_vault_id = azurerm_key_vault.k8s_keyvault.id
}
