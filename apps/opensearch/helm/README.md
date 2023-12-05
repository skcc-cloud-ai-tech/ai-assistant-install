# Opensearch: `helm`

See: https://github.com/opensearch-project/helm-charts


## Pre-requisite

`/etc/sysctl.conf`:

```bash
vm.max_map_count = 262144
```

PV/PVC
```bash
kubectl create namespace opensearch

kubectl apply -f volumes/nfs-pv.yaml
kubectl apply -f volumes/nfs-pvc.yaml
```

## Install

```bash
helm repo add opensearch https://opensearch-project.github.io/helm-charts/
helm repo update
```

```bash
$ helm search repo opensearch
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                           
opensearch/opensearch                   2.13.1          2.8.0           A Helm chart for OpenSearch           
opensearch/opensearch-dashboards        2.11.1          2.8.0           A Helm chart for OpenSearch Dashboards
```

```bash
helm pull opensearch/opensearch \
  --version "2.13.1" \
   --untar

helm pull opensearch/opensearch-dashboards \
  --version "2.11.1" \
  --untar
```


```bash
helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards.yaml
```

```bash

helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-http.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-http.yaml
```

* private:

```bash
helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-http-private.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-http-private.yaml
```


* `TLS`

```bash
helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-tls.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-tls.yaml
```

```bash
az aks update --enable-blob-driver -n aks-data-dev -g rg-quickdrawai
```