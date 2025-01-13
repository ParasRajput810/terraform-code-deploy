resource "azurerm_resource_group" "mRG" {
    name     = "projectrg"
    location = "Canada Central"
}

resource "azurerm_app_service_plan" "myplan" {
    name                = "projectappplan"
    location            = azurerm_resource_group.mRG.location
    resource_group_name = azurerm_resource_group.mRG.name
    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_app_service" "my_app_service_plan" {
    app_service_plan_id = azurerm_app_service_plan.myplan.id
    name                = "projectcobra"
    location            = azurerm_resource_group.mRG.location
    resource_group_name = azurerm_resource_group.mRG.name

    site_config {
        use_32_bit_worker_process = true
    }
}

resource "null_resource" "upload_index_html" {
  provisioner "local-exec" {
    command =<<EOT
      echo "Current working directory: $(pwd)"
      
      # List files in the current directory to see what's available
      echo "Files in the current directory:"
      ls -la

      # Create a zip file containing index.html from the root of the project
      zip -r ${path.module}/index.zip ${path.module}/../index.html
 
      # Upload the zip file to the Azure App Service
      az webapp deployment source config-zip \
        --resource-group ${azurerm_resource_group.mRG.name} \
        --name ${azurerm_app_service.my_app_service_plan.name} \
        --src ${path.module}/index.zip
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [azurerm_app_service.my_app_service_plan]
}

## Deployment55