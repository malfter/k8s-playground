#!/usr/bin/env bash

kubectl apply -f ingress-gateway/service-defaults.yaml
kubectl apply -f ingress-gateway/ingress-gateway.yaml
