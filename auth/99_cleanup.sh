#!/usr/bin/env bash

CLUSTER_NAME=demo

kubectl config delete-cluster ${CLUSTER_NAME}

for index in {1..5}; do
    kubectl config delete-context "user0${index}-${CLUSTER_NAME}"
    kubectl config delete-user "user0${index}-${CLUSTER_NAME}"
done

set -x

rm -f "${HOME}/.kube/certs/${CLUSTER_NAME}/k8s-ca.crt"