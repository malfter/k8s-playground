# k8s-playground

<img src="assets/kubernetes.png" alt="kubernetes" width="100"/>

This project can be used to try out various frameworks around Kubernetes.

## Table of Contents

- [k8s-playground](#k8s-playground)
  - [Table of Contents](#table-of-contents)
  - [Topics](#topics)
    - [Authentication and Authorization](#authentication-and-authorization)
    - [GitOps](#gitops)
    - [Kustomize](#kustomize)
    - [Secrets](#secrets)
    - [Service Mesh](#service-mesh)

## Topics

### Authentication and Authorization

To test multiple kubernetes authentication and authorization variants, the section `auth` was created, see [auth/README](auth/README.md).

### GitOps

Testing of GitOps tools [gitops/README](gitops/README.md)

### Kustomize

Some examples with kustomize, see [kustomize/README](kustomize/README.md).

### Secrets

Handle secrets in kubernetes:

- [secrets/akv2k8s/README](secrets/akv2k8s/README.md)

### Service Mesh

- [service-mesh/hashicorp-consul/README](service-mesh/hashicorp-consul/README.md)
- [service-mesh/openservicemesh/README](service-mesh/openservicemesh/README.md)
