#!/usr/bin/env bash

set -ex

NAMESPACE=demo-app

kubectl create namespace $NAMESPACE

kubectl create secret -n demo-app generic root-ca --from-file=ca.pem=ssl/ca.pem

# Installs demo-app
sed "s/{{MINIKUBE_IP}}/$( minikube ip )/g" demo-app.yaml | kubectl apply -n $NAMESPACE -f -

kubectl apply -f clusterusers-clusterrolebinding.yaml

kubectl apply -f clusterusers-rolebinding.yaml -n $NAMESPACE

set +x

until [ "$( kubectl get ingress -n "${NAMESPACE}" | grep demo-app | grep -o "$( minikube ip )" | wc -l)" -eq 2 ]; do echo "Waiting for ingress ..."; sleep 3; done
