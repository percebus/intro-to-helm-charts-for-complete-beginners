# intro-to-helm-charts-for-complete-beginners

## HISTORY

### Create a Chart Directory

#### helm create

This command will create a directory named helm-experiments with a basic chart structure and a set of files.

1. `helm create helm-experiments && cd helm-experiments`

The helm-experiments directory will contain several files and subdirectories:

* `Chart.yaml`: This file contains metadata about the current chart, such as the name,  chart version, and description.
* `values.yaml`: This file defines the default configuration values for your chart.
* `templates/`: The templates directory contains the template files for your Kubernetes manifests (e.g., Deployments, Services, ConfigMaps).
* `charts/`: This directory stores chart dependencies if your chart relies on other charts.

To keep this demonstration simple, we would need to remove some of the generated files Helm created, in your terminal run the following commands:

#### rm templates

1. `$> rm templates/hpa.yaml templates/ingress.yaml templates/serviceaccount.yaml`

Helm generated manifests for a HorizontalPodAutoscaler ,  an ingress as well as a service account, which we would not be needing for this demonstration.  If this fits your use case feel free to leave them.

At this point, your folder structure should look something like this:

```bash
.
├── Chart.yaml
├── charts
├── templates
│  ├── _helpers.tpl
│  ├── deployment.yaml
│  ├── NOTES.txt
│  ├── service.yaml
│  └── tests
│     └── test-connection.yaml
└── values.yaml
```

#### values.yml

Next, let’s change the default values helm generated, in your editor of choice open up values.yaml  , it should look something like this:

```helm
# Default values for helm-experiments.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}

podSecurityContext: {}
  # fsGroup: 2000

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

resources: {}
.....
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}
```

Edit the manifest so it looks like this:

```helm
replicaCount: 2

image:
  repository: traefik/whoami
  tag: "latest"
  pullPolicy: Always

service:
  name: whoami-svc
  type: ClusterIP
  port: 80
  targetPort: 80
```

In the updated manifest we

* Set the replicaCount to two
* set the image repository tag and pull policy.
* On lines 8-12 we define the `service` `name`, `type` and `ports`: this is where helm’s templating comes into play as we can have different service types for each environment

As an example, for development we could have the service be of `type` `ClusterIP` and in Q/A or prod the service can be exposed as `LoadBalancer`.
