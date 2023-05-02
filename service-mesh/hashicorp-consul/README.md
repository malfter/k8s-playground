# k8s-playground - Topic Service Mesh - Hashicorp Consul

## Table of contents

- [k8s-playground - Topic Service Mesh - Hashicorp Consul](#k8s-playground---topic-service-mesh---hashicorp-consul)
  - [Table of contents](#table-of-contents)
  - [Setup minikube with consul](#setup-minikube-with-consul)
    - [Access the Consul UI](#access-the-consul-ui)
    - [Access Consul with kubectl and the HTTP API](#access-consul-with-kubectl-and-the-http-api)
  - [Consul Intentions](#consul-intentions)
    - [Create an intention that denies communication](#create-an-intention-that-denies-communication)
    - [Allow the application dashboard to communicate with the Counting service](#allow-the-application-dashboard-to-communicate-with-the-counting-service)
  - [Consul Ingress-Gateway](#consul-ingress-gateway)
    - [⚠️ IMPORTANT Cannot access Services via NodePort on MacOS M1 with driver docker](#️-important-cannot-access-services-via-nodeport-on-macos-m1-with-driver-docker)
  - [What it does](#what-it-does)
    - [01\_minikube\_start.sh](#01_minikube_startsh)
    - [02\_consul.sh](#02_consulsh)
    - [03\_services.sh](#03_servicessh)
    - [04\_ingress-gateway.sh](#04_ingress-gatewaysh)

## Setup minikube with consul

![dex-k8s-authenticator.drawio.png](dex-k8s-authenticator.drawio.png)

Simply run the scripts in order:

        ./01_minikube_start.sh
        ./02_consul.sh
        ./03_services.sh

        # Make your tests ;-)

        # Delete minikube-demo
        minikube delete

### Access the Consul UI

    kubectl --namespace consul port-forward service/consul-ui 8080:80 --address 0.0.0.0

### Access Consul with kubectl and the HTTP API

In addition to accessing Consul with the UI, you can manage Consul with the HTTP API or by directly connecting to the pod with kubectl.

    kubectl exec --stdin --tty consul-server-0 --namespace consul -- /bin/sh

## Consul Intentions

### Create an intention that denies communication

    kubectl apply -f services/deny.yaml

### Allow the application dashboard to communicate with the Counting service

    kubectl delete -f deny.yaml

## Consul Ingress-Gateway

    # Call "default" service (currently: static-server)
    curl $(minikube service -n consul --url consul-ingress-gateway)

    # Call "dashboard" service
    curl -H "Host: dashboard.example.consul" $(minikube service -n consul --url consul-ingress-gateway)

### ⚠️ IMPORTANT Cannot access Services via NodePort on MacOS M1 with driver docker

The access via the NodePort(s) unfortunately does not work under MacOS M1, here you have to resort to port forwarding:

    kubectl --namespace consul port-forward service/consul-ingress-gateway 30099:9999

    # Call "default" service (currently: static-server)
    curl http://127.0.0.1:30099

    # Call "dashboard" service
    curl -H "Host: dashboard.example.consul" http://127.0.0.1:30099

## What it does

See the scripts for more details.

### 01_minikube_start.sh

Starts simple minikube instance.

### 02_consul.sh

Installs Consul Service-Mesh into minikube instance.

### 03_services.sh

Installs some demo services.

### 04_ingress-gateway.sh

Installs and configures an Consul ingress-gateway example.
