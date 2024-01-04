# Prometheus Node-Exporter: `helm`

See: https://github.com/bitnami/charts/tree/main/bitnami/node-exporter
See: https://bitnami.com/stack/node-exporter/helm


## Install

```bash
# helm repo add node-exporter oci://registry-1.docker.io/bitnamicharts/node-exporter --debug
# helm repo update
```


```bash
helm pull oci://registry-1.docker.io/bitnamicharts/node-exporter \
  --version "3.9.6" \
   --untar
```

```bash
helm upgrade --install node-exporter \
  ./node-exporter \
  -n monitoring \
  --create-namespace \
  -f values-node-exporter.yaml

```

```bash
helm uninstall node-exporter \
  -n monitoring

```