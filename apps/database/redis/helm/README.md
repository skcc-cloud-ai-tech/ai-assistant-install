# Redis: `helm`

See: https://artifacthub.io/packages/helm/bitnami/redis

## Install

```bash
helm repo add redis oci://registry-1.docker.io/bitnamicharts/redis
helm repo update
```

```bash
$ helm search repo opensearch
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                           
opensearch/opensearch                   2.13.1          2.8.0           A Helm chart for OpenSearch           
opensearch/opensearch-dashboards        2.11.1          2.8.0           A Helm chart for OpenSearch Dashboards
```

```bash
helm pull oci://registry-1.docker.io/bitnamicharts/redis \
  --version "17.11.5" \
   --untar
```

```bash
helm upgrade --install redis \
  ./redis \
  -n redis \
  --create-namespace \
  -f values-redis.yaml
```

```bash

```