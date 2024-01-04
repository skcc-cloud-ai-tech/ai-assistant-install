

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm search repo prometheus-community

```bash
helm pull prometheus-community/prometheus-node-exporter \
  --version "4.24.0" \
   --untar
```

```bash
helm upgrade --install node-exporter \
  ./prometheus-node-exporter \
  -n monitoring \
  --create-namespace \
  -f values-node-exporter.yaml

```

```bash
helm uninstall node-exporter \
  -n monitoring

```