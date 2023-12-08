

```bash
helm repo add metallb https://metallb.github.io/metallb
helm repo update

helm search repo metallb
# NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
# metallb/metallb 0.13.12         v0.13.12        A network load-balancer implementation for Kube...

helm pull metallb/metallb \
  --version "0.13.12" \
  --untar

```

* At first, edit `configmap/kube-proxy` in `kube-system`:

```bash
kubectl edit configmap -n kube-system kube-proxy
```

```yaml
    ipvs:
      excludeCIDRs: null
      minSyncPeriod: 0s
      scheduler: ""
      # strictARP: false
      strictARP: true
      syncPeriod: 0s
      tcpFinTimeout: 0s
      tcpTimeout: 0s
      udpTimeout: 0s
    kind: KubeProxyConfiguration
    metricsBindAddress: ""
    # mode: ""
    mode: "ipvs"
```


```bash

helm upgrade --install metallb \
  ./metallb \
  -n metallb-system \
  --create-namespace \
  -f values-metallb.yaml
```

```bash
kubectl apply -f ipaddresspool.yaml
```