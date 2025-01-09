resource "azurerm_resource_group" "mRG" {
    name = "projectrg"
    location = "Canada Central"
}

resource "azurerm_app_service_plan" "myplan" {
  name = "projectappplan"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "my_app_service_plan" {
  app_service_plan_id = azurerm_app_service_plan.myplan.id
  name = "projectcobra"
  location = azurerm_resource_group.mRG.location
  resource_group_name = azurerm_resource_group.mRG.name

  site_config {
    use_32_bit_worker_process = true  # Enable 32-bit worker processes
  }
}

resource "local_file" "index_html" {
  content  = file("index.html")
  filename = "/index.html"
}

resource "null_resource" "upload_index_html" {
  provisioner "local-exec" {
    command = <<EOT
      az webapp up --name projectcobra --resource-group ${azurerm_resource_group.mRG.name} --location ${azurerm_resource_group.mRG.location} --html
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [azurerm_app_service.example]
}

