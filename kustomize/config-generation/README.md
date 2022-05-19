# Kustomize ConfigMap generation - Restart pods when ConfigMap updates in Kubernetes

The current best solution to this problem (referenced deep in [https://github.com/kubernetes/kubernetes/issues/22368] linked in the sibling answer) is to use Deployments, and consider your ConfigMaps to be immutable.

When you want to change your config, create a new ConfigMap with the changes you want to make, and point your deployment at the new ConfigMap. If the new config is broken, the Deployment will refuse to scale down your working ReplicaSet. If the new config works, then your old ReplicaSet will be scaled to 0 replicas and deleted, and new pods will be started with the new config.

Kustomize offers the possibility to append a hash suffix to the name of a ConfigMap based on its content, see how it works:

My [base/kustomization.yaml](config-generation/base/kustomization.yaml)

    resources:
    - deployment.yaml

and a [base/deployment.yaml](config-generation/base/deployment.yaml)

        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: my-deployment
        spec:
        selector:
            matchLabels:
            app.kubernetes.io/name: my-deployment
        replicas: 1
        template:
            metadata:
            labels:
                app.kubernetes.io/name: my-deployment
            spec:
            containers:
                - name: my-container
                image: my-image:1.0
                env:
                - name: MY_VAR
                    valueFrom:
                    configMapKeyRef:
                        name: my-cm
                        key: my.properties

and an overlay [overlay/kustomization.yaml](overlay/kustomization.yaml):

    resources:
    - ../base

    configMapGenerator:
      - name: my-cm
        files:
          - my.properties

Let's see what happens:

    kustomize build

The resulting ConfigMap names have 10 alpha-numeric characters added to the end:

    apiVersion: v1
    data:
      my.properties: my-prop=my-value
    kind: ConfigMap
    metadata:
      name: my-cm-cbhb2bk66k  # <-- with hash suffix
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-deployment
    spec:
      replicas: 1
      selector:
        matchLabels:
          app.kubernetes.io/name: my-deployment
      template:
        metadata:
          labels:
            app.kubernetes.io/name: my-deployment
        spec:
          containers:
          - env:
            - name: MY_VAR
              valueFrom:
                configMapKeyRef:
                  key: my.properties
                  name: my-cm-cbhb2bk66k  # <-- with hash suffix
            image: my-image:1.0
            name: my-container


### Links

- [https://github.com/kubernetes-sigs/kustomize/blob/master/examples/configGeneration.md]
- [https://localcoder.org/restart-pods-when-configmap-updates-in-kubernetes#solution_1]
- [https://pauldally.medium.com/why-is-kustomize-adding-a-bunch-of-characters-to-my-secret-configmap-names-b1572741c846]
