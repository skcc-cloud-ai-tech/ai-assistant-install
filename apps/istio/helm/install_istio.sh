
helm upgrade --install istio-base \
    ./base \
    -n istio-system \
    --create-namespace \
  -f values-base.yaml

helm upgrade --install istio-istiod \
    ./istiod \
    -n istio-system \
    --create-namespace \
  -f values-istiod.yaml \
  --wait

helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
    --create-namespace \
  -f values-gateway-aks.yaml \
  --wait

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