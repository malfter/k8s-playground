.PHONY: help init clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

help:  ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## 🌱 Init k8s cluster
	brew install k3d
	brew install helm

init:  ## 🌱 Init k8s cluster
  # Create cluster
	k3d cluster list --no-headers | grep mycluster >> /dev/null || k3d cluster create mycluster
	# Install argocd
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm dep update charts/argo-cd/
	helm list --no-headers | grep argo-cd > /dev/null && helm upgrade argo-cd charts/argo-cd/ || helm install argo-cd charts/argo-cd/
	# Install argocd applications, argocd managed itself
	helm template apps/ | kubectl apply -f -
	# Once the Argo CD application is synced it can now manage itself and
	# we can delete the previously manually installed (via helm install) installation.
	# The following command will not delete Argo CD from the cluster, only let Helm know that it is not managing Argo CD anymore:
  kubectl delete secret -l owner=helm,name=argo-cd

clean:  ## 🧹 Clean up resources
	k3d cluster delete mycluster
