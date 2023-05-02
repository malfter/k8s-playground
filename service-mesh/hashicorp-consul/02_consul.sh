#!/usr/bin/env bash

CONSUL_VERSION=0.43.0

helm repo add hashicorp https://helm.releases.hashicorp.com

helm install \
    --values helm-consul-values.yaml \
    consul hashicorp/consul \
    --create-namespace \
    --namespace consul \
    --version "$CONSUL_VERSION"

until [ "$( kubectl get pods -n consul | grep consul-server | grep Running | wc -l)" -eq 1 ]; do echo "Waiting for Consul ..."; sleep 3; done
