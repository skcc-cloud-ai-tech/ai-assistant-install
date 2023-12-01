

```bash
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.19.0 TARGET_ARCH=x86_64 sh -

```

```bash
curl -fsSL https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/prometheus.yaml -o prometheus-istio-1.19-extra.yaml

kubectl apply -f prometheus-istio-1.19-extra.yaml

curl -fssL https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/grafana.yaml -o grafana-istio-1.19-extra.yaml

kubectl apply -f grafana-istio-1.19-extra.yaml
```

```bash
# curl -fsSL https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/extras/zipkin.yaml -o zipkin-istio-1.19-extra.yaml

# kubectl apply -f zipkin-istio-1.19-extra.yaml
```

```bash
curl -fsSL https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/jaeger.yaml -o jaeger-istio-1.19-extra.yaml

kubectl apply -f jaeger-istio-1.19-extra.yaml
```

```bash
echo $RANDOM | md5sum | head -c 32; echo;

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kiali-signing-key-manual-token
  namespace: istio-system
  annotations:
    kubernetes.io/service-account.name: kiali
type: kubernetes.io/service-account-token
EOF
```



```yaml
spec:
  server:
    web_fqdn: apps.example.com
    web_port: 8080
    web_root: /dashboards/kiali
    web_schema: https
```

```bash
curl -fsSL https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/kiali.yaml -o kiali-istio-1.19-extra.yaml

kubectl apply -f kiali-istio-1.19-extra.yaml
```

```bash
kubectl apply -f virtualservice.yaml
```