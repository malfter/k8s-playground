#!/usr/bin/env bash

kubectl apply -f services/counting.yaml
kubectl apply -f services/dashboard.yaml

kubectl apply -f services/static-server.yaml
kubectl apply -f services/static-client.yaml