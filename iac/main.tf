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
    command = <<EOT
      # Log the current working directory
      echo "Current working directory: $(pwd)"
      
      # List files in the current directory to see what's available
      echo "Files in the current directory:"
      ls -la

      # Define the absolute path for the index.html file in the project root
      PROJECT_ROOT=${path.module}/../

      # Log the absolute path of the index.html file
      echo "Absolute path to index.html: ${PROJECT_ROOT}index.html"

      # Check if the index.html file exists in the given path
      if [ -f ${PROJECT_ROOT}index.html ]; then
        echo "index.html file found."
      else
        echo "index.html file not found."
        exit 1
      fi

      # Create a zip file containing index.html from the project root
      zip -r ${PROJECT_ROOT}index.zip ${PROJECT_ROOT}index.html

      # Log if the zip was created successfully
      if [ -f ${PROJECT_ROOT}index.zip ]; then
        echo "index.zip file created successfully."
      else
        echo "Failed to create index.zip."
        exit 1
      fi

      # Upload the zip file to the Azure App Service
      az webapp deployment source config-zip \
        --resource-group projectrg \
        --name projectcobra \
        --src ${PROJECT_ROOT}index.zip
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [azurerm_app_service.my_app_service_plan]
}


