# K8s secrets with akv2k8s

Azure Key Vault to Kubernetes (akv2k8s) makes Azure Key Vault secrets, certificates and keys available in Kubernetes and/or your application - in a simple and secure way.

Documentation: [https://akv2k8s.io/]

## Local environment

We use k3d to create a cluster: [https://k3d.io]

k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.

### Create local cluster

```bash
# Set azure environment variables
export TF_VAR_azurerm_tenant_id=<azure-tenant-id>
export TF_VAR_azurerm_subscription_id=<azure-tenant-id>
export TF_VAR_azurerm_client_id=<azure-client-id>
export TF_VAR_azurerm_client_secret=<azure-client-secret>

# Set keyvault name
export TF_VAR_keyvault_name="k8skeyvault-xIzd"

# Create azure keyvault with secret
make init-azure

# Create k8s cluster and install resources
make init-k8s

# Cleanup and delete all resources
make clean
```

### Check secret in application

```bash
$ kubectl -n akv-test logs deployment/akvs-secret-app
mysecretvalue
waiting forever...
```
