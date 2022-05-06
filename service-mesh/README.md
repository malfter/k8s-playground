# k8s-playground - Topic Service Mesh

## Table of contents

- [k8s-playground - Topic Service Mesh](#k8s-playground---topic-service-mesh)
  - [Table of contents](#table-of-contents)
  - [Setup minikube with consul](#setup-minikube-with-consul)
    - [Access the Consul UI](#access-the-consul-ui)
    - [Access Consul with kubectl and the HTTP API](#access-consul-with-kubectl-and-the-http-api)
  - [Intentions](#intentions)
    - [Create an intention that denies communication](#create-an-intention-that-denies-communication)
    - [Allow the application dashboard to communicate with the Counting service](#allow-the-application-dashboard-to-communicate-with-the-counting-service)
    - [What it does](#what-it-does)
      - [01_minikube_start.sh](#01_minikube_startsh)
      - [02_consul.sh](#02_consulsh)
      - [03_services.sh](#03_servicessh)

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

## Intentions

### Create an intention that denies communication

    kubectl apply -f services/deny.yaml

### Allow the application dashboard to communicate with the Counting service

    kubectl delete -f deny.yaml

### What it does

See the scripts for more details.

#### 01_minikube_start.sh

Starts simple minikube instance.

#### 02_consul.sh

TODO

#### 03_services.sh

TODO
