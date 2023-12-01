# Redis: `helm`

See: https://artifacthub.io/packages/helm/bitnami/redis

## Install

```bash
helm repo add redis oci://registry-1.docker.io/bitnamicharts/redis
helm repo update
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

```bash
  - name: redis
    port: 6379
    protocol: TCP
    targetPort: 6379
```