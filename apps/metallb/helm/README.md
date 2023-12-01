

```bash
helm repo add metallb https://metallb.github.io/metallb
helm repo update

helm search repo metallb
# NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
# metallb/metallb 0.13.12         v0.13.12        A network load-balancer implementation for Kube...

helm pull metallb/metallb \
  --version "0.13.12" \
  --untar

helm upgrade --install metallb \
  ./metallb \
  -n metallb \
  -f values-metallb.yaml
```
