# GitOps

- [GitOps](#gitops)
  - [Local environment](#local-environment)
    - [Create local cluster](#create-local-cluster)
    - [Accessing the ArgoCD Web UI](#accessing-the-argocd-web-ui)
    - [Delete local cluster](#delete-local-cluster)
  - [TODO](#todo)

## Local environment

We use k3d to create a cluster: [https://k3d.io]

k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.

### Create local cluster

```bash
# Create cluster
make init

# Install argocd applications
make argocd
```

### Accessing the ArgoCD Web UI

The Helm chart doesn’t install an Ingress by default, to access the Web UI we have to port-forward to the argocd-server service:

```bash
kubectl port-forward svc/argo-cd-argocd-server 8080:443
```

We can then visit http://localhost:8080 to access it.

The default username is `admin`. The password is auto-generated and we can get it with:

```bash
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Delete local cluster

```bash
make clean
```

## TODO

- [ ] Install argocd-cli (Download from argocd-server)
- [ ] Use ingress to access argocd webui: [https://k3d.io/v5.4.6/usage/exposing_services/]
