.PHONY: help check-env init clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

help:  ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## 🛠️  Install tools
	brew install k3d
	brew install helm

check-env:  ## ✔️ Check if the environment variables are set to run terrafrom commands
	echo "Nothing to check"
# ifndef MY_VAR
# 	$(error MY_VAR is undefined, set 'export MY_VAR=<value>')
# endif


init: check-env  ## 🌱 Init k8s cluster
  # Create cluster
	k3d cluster list --no-headers | grep mycluster >> /dev/null || (k3d cluster create mycluster --wait && ../../scripts/wait.sh 45)
	# Install neuvector
	helm repo add neuvector https://neuvector.github.io/neuvector-helm/
	helm repo update
	helm upgrade --install neuvector neuvector/core \
		--create-namespace \
		--namespace neuvector \
		--set k3s.enabled=true

apply:  ## 🛂 Apply NeuVector configuration
	kubectl apply -f security-rules/*.yaml

clean:  ## 🧹 Clean up resources
	k3d cluster delete mycluster
