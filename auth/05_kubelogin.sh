#!/usr/bin/env bash

set -e

which kubelogin >> /dev/null || brew install int128/kubelogin/kubelogin

MINIKUBE_DOMAIN=$( minikube ip ).nip.io

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl config set-credentials user01 \
    --exec-api-version=client.authentication.k8s.io/v1beta1 \
    --exec-command=kubectl \
    --exec-arg=oidc-login \
    --exec-arg=get-token \
    --exec-arg=--oidc-issuer-url=https://dex.${MINIKUBE_DOMAIN}:32000 \
    --exec-arg=--oidc-client-id=example-app \
    --exec-arg=--oidc-client-secret=ZXhhbXBsZS1hcHAtc2VjcmV0 \
    --exec-arg=--oidc-extra-scope=profile \
    --exec-arg=--oidc-extra-scope=email \
    --exec-arg=--oidc-extra-scope=groups \
    --exec-arg=--certificate-authority=${SCRIPT_DIR}/ssl/ca.pem