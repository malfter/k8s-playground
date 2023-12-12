.PHONY: help check-env init-azure init-k8s clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

TF_ROOT = azure-resources
K8S_ROOT = k8s-resources

help:  ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## 🛠️  Install tools
	brew install k3d
	brew install helm

check-env:  ## ✔️ Check if the environment variables are set to run terrafrom commands
ifndef TF_VAR_azurerm_tenant_id
	$(error TF_VAR_azurerm_tenant_id is undefined, set 'export TF_VAR_azurerm_tenant_id=<azure-tenant-id>')
endif
ifndef TF_VAR_azurerm_subscription_id
	$(error TF_VAR_azurerm_subscription_id is undefined, set 'export TF_VAR_azurerm_subscription_id=<azure-tenant-id>')
endif
ifndef AZURE_CLIENT_ID
	$(error TF_VAR_azurerm_client_id is undefined, set 'export TF_VAR_azurerm_client_id=<azure-client-id>')
endif
ifndef AZURE_CLIENT_SECRET
	$(error TF_VAR_azurerm_client_secret is undefined, set 'export TF_VAR_azurerm_client_secret=<azure-client-secret>')
endif

init-azure: check-env  ## 🌱 Init azure resources
	cd $(TF_ROOT) && terraform init
	cd $(TF_ROOT) && terraform apply

init-k8s: check-env  ## 🌱 Init k8s cluster
  # Create cluster
	k3d cluster list --no-headers | grep mycluster >> /dev/null || (k3d cluster create mycluster --wait && ../../scripts/wait.sh 45)
	# Install akv2k8s
	helm repo add spv-charts https://charts.spvapi.no
	helm repo update
	helm upgrade --install akv2k8s spv-charts/akv2k8s \
		--create-namespace \
		--namespace akv2k8s \
		--set global.keyVaultAuth=environment \
		--set global.env.AZURE_TENANT_ID=$(TF_VAR_azurerm_tenant_id) \
		--set global.env.AZURE_CLIENT_ID=$(TF_VAR_azurerm_client_id) \
		--set global.env.AZURE_CLIENT_SECRET=$(TF_VAR_azurerm_client_secret)
	kubectl apply -f $(K8S_ROOT)/ns-akv-test.yaml
	kubectl apply -f $(K8S_ROOT)/akvs-secret-inject.yaml
	kubectl apply -f $(K8S_ROOT)/deploy-akvs-secret-app.yaml

clean:  ## 🧹 Clean up resources
	k3d cluster delete mycluster
	cd $(TF_ROOT) && terraform destroy
