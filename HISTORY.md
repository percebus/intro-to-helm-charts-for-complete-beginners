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
