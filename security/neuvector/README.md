# K8s security with NeuVector

NeuVector Full Lifecycle Container Security Platform delivers the only cloud-native security with uncompromising end-to-end protection from DevOps vulnerability protection to automated run-time security, and featuring a true Layer 7 container firewall.

A viewable version of docs can be seen at [https://open-docs.neuvector.com].

## Links

- [https://github.com/neuvector/neuvector]
- [https://github.com/neuvector/neuvector-helm]
- [https://github.com/neuvector/manifests]

## Local environment

We use k3d to create a cluster: [https://k3d.io]

k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.

### Create local cluster

```bash
# Create k8s cluster and install NeuVector
make init

# Apply example configuration
make apply

# Open neuvector webui and login with:
# username: admin
# password: admin
NODE_PORT=$(kubectl get --namespace neuvector -o jsonpath="{.spec.ports[0].nodePort}" services neuvector-service-webui)
NODE_IP=$(kubectl get nodes --namespace neuvector -o jsonpath="{.items[0].status.addresses[0].address}")
open https://$NODE_IP:$NODE_PORT

# Cleanup and delete all resources
make clean
```
