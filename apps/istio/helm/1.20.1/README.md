

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
    --version "1.20.1" \
    --untar

helm upgrade --install istio-base \
    ./base \
    -n istio-system \
  -f values-base.yaml
    
```

* `discovery`

```bash
helm pull istio/istiod \
    --version "1.20.1" \
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
    --version "1.20.1" \
    --untar

# helm upgrade --install istio-gateway \
#     ./gateway \
#     -n istio-system \
#   -f values-gateway.yaml \
#   --wait
helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
  -f values-gateway-aks-internal.yaml \
  --wait

helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
  -f values-gateway-aks.yaml \
  --wait

helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
  -f values-gateway-nodeport.yaml \
  --wait
```

```bash
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: istio-http-gateway
  namespace: istio-system
spec:
  selector:
    # app: istio-gateway
    istio: gateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
  # - port:
  #     number: 443
  #     name: https
  #     protocol: HTTPS
  #   tls:
  #     mode: SIMPLE
  #     serverCertificate: /etc/istio/ingressgateway-certs/tls.crt
  #     privateKey: /etc/istio/ingressgateway-certs/tls.key
  #   hosts:
  #   - dev.api.storefront-demo.com
  #   - test.api.storefront-demo.com
  #   - uat.api.storefront-demo.com
EOF
```