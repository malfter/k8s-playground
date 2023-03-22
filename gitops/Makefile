.PHONY: help init clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

help:  ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## 🌱 Init k8s cluster
	brew install k3d
	brew install helm

init:  ## 🌱 Init k8s cluster
	k3d cluster list --no-headers | grep mycluster >> /dev/null || k3d cluster create mycluster
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm dep update charts/argo-cd/
	helm install argo-cd charts/argo-cd/

clean:  ## 🧹 Clean up resources
	k3d cluster delete mycluster
