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

# kubectl apply -f redis-pv-private.yaml && \
# kubectl apply -f redis-pvc-private.yaml && \
helm upgrade --install redis \
  ./redis \
  -n redis \
  --create-namespace \
  -f values-redis-private.yaml
```

```bash
helm uninstall -n redis redis
```

```bash
  - name: redis
    port: 6379
    protocol: TCP
    targetPort: 6379
```