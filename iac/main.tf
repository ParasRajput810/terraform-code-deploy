resource "azurerm_resource_group" "mRG" {
    name = "projectrg"
    location = "East US"
}

resource "azurerm_app_service_plan" "myplan" {
  name = "projectappplan"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "my_app_service_plan" {
  app_service_plan_id = azurerm_app_service_plan.myplan.id
  name = "projectcobra"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name

  site_config {
    scm_type = "GitHub"
  }
}


