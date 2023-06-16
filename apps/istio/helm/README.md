

See: https://istio.io/latest/docs/setup/install/helm/

```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```

```bash
helm search repo istio
```

* `namespace`

```bash
kubectl create namespace istio-system
```

* `base`

```bash
helm pull istio/base \
    --version "1.18.0" \
    --untar

helm upgrade --install istio-base \
    ./base \
    -n istio-system \
  -f values-base.yaml
    
```

* `discovery`

```bash
helm pull istio/istiod \
    --version "1.18.0" \
    --untar

helm upgrade --install istio-istiod \
    ./istiod \
    -n istio-system \
  -f values-istiod.yaml \
  --wait
```

* (Optional) `ingress`

```bash
helm pull istio/gateway \
    --version "1.18.0" \
    --untar

# helm upgrade --install istio-gateway \
#     ./gateway \
#     -n istio-system \
#   -f values-gateway.yaml \
#   --wait
helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
  -f values-gateway-aks.yaml \
  --wait
```
