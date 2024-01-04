

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm search repo ingress-nginx
# NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
# ingress-nginx/ingress-nginx     4.9.0           1.9.5           Ingress controller for Kubernetes using NGINX a...
```

```bash
helm pull ingress-nginx/ingress-nginx  \
  --version "4.9.0" \
   --untar
```

```bash
helm upgrade --install ingress-nginx \
  ./ingress-nginx \
  -n ingress-nginx \
  --create-namespace \
  -f values-nginx.yaml

helm uninstall -n ingress-nginx ingress-nginx
```
