resource "azurerm_resource_group" "mRG" {
    name = "projectrg"
    location = "East US"
}

resource "azurerm_app_service_plan" "myplan" {
  name = "my_app_service_plan"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "my_app_service_plan" {
  app_service_plan_id = azurerm_app_service_plan.myplan.id
  name = "myApp"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name

  site_config {
    scm_type = "GitHub"
  }
}


