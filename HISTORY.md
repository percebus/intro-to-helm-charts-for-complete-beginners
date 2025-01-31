# intro-to-helm-charts-for-complete-beginners

## HISTORY

### How to Create a Helm Chart

#### Create a Chart Directory

##### helm create

1. `$> helm create helm-experiments`
1. `$> helm-experiments`

##### rm templates

1. `$> rm templates/hpa.yaml templates/ingress.yaml templates/serviceaccount.yaml`

##### values.yml

Edit the `values.yml` so it looks like this:

```yaml
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

#### Creating a Deployment

##### deployment.yml

Replace the contents `deployment` manifest with the configuration below:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-app
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}-app
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-app
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
        ports:
        - containerPort: {{ .Values.service.port }}
```

#### Fix NOTES.txt

1. `$> helm install helm-experiments .`

> [!CAUTION]
> Seems that we deleted something in the `templates` folder that is still being referenced in the `NOTES.txt` file.

```shell
Error: INSTALLATION FAILED: template: helm-experiments/templates/NOTES.txt:2:14: executing "helm-experiments/templates/NOTES.txt" at <.Values.ingress.enabled>: nil pointer evaluating interface {}.enabled
```

Made a simplified `NOTES.txt` file

```yaml
# NOTES

## Top-Level

- replicaCount: {{ .Values.replicaCount }}

## image

- image: {{ .Values.image.repository }}@{{ .Values.image.tag }}
- pullPolicy: {{ .Values.image.pullPolicy }}

## service ({{ .Values.service.type }})

- name: {{ .Values.service.name }}
- ports: {{ .Values.service.port }}:{{ .Values.service.targetPort }}
```

#### First install

1. `$> helm install helm-experiments .`

```shell
NAME: helm-experiments
LAST DEPLOYED: Fri Jan 31 11:40:52 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
# NOTES

## Top-Level

- replicaCount: 2

## image

- image: traefik/whoami@latest
- pullPolicy: Always

## service ( ClusterIP )

- name: whoami-svc
- ports: 80:80
```

#### Check the pods

1. `$> kubectl get pods`

```shell
$ kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
helm-experiments-app-598bfd659f-99lm8   1/1     Running   0          4m37s
helm-experiments-app-598bfd659f-qgxdm   1/1     Running   0          4m37s
```

#### Check the service

1. `$> kubectl get svc`

```shell
$ kubectl get svc
NAME               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
helm-experiments   ClusterIP   10.97.57.87   <none>        80/TCP    8m29s
kubernetes         ClusterIP   10.96.0.1     <none>        443/TCP   22m
```

### How to Host a Helm Chart

#### Push the Helm chart

1. `$> helm push helm-experiments-0.1.0.tgz oci://ttl.sh/jcystems-helm-experiments`

```shell
$ helm push helm-experiments-0.1.0.tgz oci://ttl.sh/jcystems-helm-experiments
Pushed: ttl.sh/jcystems-helm-experiments/helm-experiments:0.1.0
Digest: sha256:dbc9a1d823cc2ee7330b188af6d8700b70d4b1db2c90ce9490acd3f969d548a7
```

### Install from the registry

1. `$ helm install helm-exp oci://ttl.sh/jcystems-helm-experiments/helm-experiments`

```shell
$ helm install helm-exp oci://ttl.sh/jcystems-helm-experiments/helm-experiments
NAME: helm-exp
LAST DEPLOYED: Fri Jan 31 13:40:07 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
# NOTES

## Top-Level

- replicaCount: 2

## image

- image: traefik/whoami@latest
- pullPolicy: Always

## service (ClusterIP)

- name: whoami-svc
- ports: 80:80
```

1. `$> kubectl get pods`

```shell
$ kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
helm-exp-app-84c58849b-jjgxx   1/1     Running   0          28s
helm-exp-app-84c58849b-wwklm   1/1     Running   0          28s
```

### Unistall

```shell
$>helm uninstall helm-exp
release "helm-exp" uninstalled
```

### Using Helm for Deployments and Rollbacks

#### Install Nginx

##### bitnami repo

1. `$> helm repo add bitnami https://charts.bitnami.com/bitnami`

```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" already exists with the same configuration, skipping
```

Seems like I have run this command before...

##### helm install

1. `$> helm install nginx bitnami/nginx`

```shell
$ helm install nginx bitnami/nginx
Error: INSTALLATION FAILED: failed to download "bitnami/nginx"
```

##### Troubleshoot

I had to re-add the repo

1. `$> helm repo remove bitnami`
1. `$> helm repo add bitnami https://charts.bitnami.com/bitnami`
1. `$> helm install nginx bitnami/nginx`

```shell
$> helm install nginx bitnami/nginx
NAME: nginx
LAST DEPLOYED: Fri Jan 31 13:48:09 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 18.3.5
APP VERSION: 1.27.3

Did you know there are enterprise versions of the Bitnami catalog? For enhanced secure software supply chain features, unlimited pulls from Docker, LTS support, or application customization, see Bitnami Premium or Tanzu Application Catalog. See https://www.arrow.com/globalecs/na/vendors/bitnami for more information.

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    nginx.default.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the NGINX URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w nginx'

    export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services nginx)
    export SERVICE_IP=$(kubectl get svc --namespace default nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "http://${SERVICE_IP}:${SERVICE_PORT}"

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - cloneStaticSiteFromGit.gitSync.resources
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
```

##### kubeclt get pods

```shell
$ kubectl get pods
NAME                    READY   STATUS    RESTARTS   AGE
nginx-8f5fd8c6d-xkbpn   1/1     Running   0          2m33s
```

##### kubectl get svc

```shell
$ kubectl get svc
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP                      144m
nginx        LoadBalancer   10.106.222.47   <pending>     80:32436/TCP,443:31124/TCP   3m4s
```
