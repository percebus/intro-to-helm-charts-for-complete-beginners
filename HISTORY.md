# intro-to-helm-charts-for-complete-beginners

## HISTORY

### Create a Chart Directory

This command will create a directory named helm-experiments with a basic chart structure and a set of files.

1. `helm create helm-experiments && cd helm-experiments`

The helm-experiments directory will contain several files and subdirectories:

* `Chart.yaml`: This file contains metadata about the current chart, such as the name,  chart version, and description.
* `values.yaml`: This file defines the default configuration values for your chart.
* `templates/`: The templates directory contains the template files for your Kubernetes manifests (e.g., Deployments, Services, ConfigMaps).
* `charts/`: This directory stores chart dependencies if your chart relies on other charts.

To keep this demonstration simple, we would need to remove some of the generated files Helm created, in your terminal run the following commands:

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
