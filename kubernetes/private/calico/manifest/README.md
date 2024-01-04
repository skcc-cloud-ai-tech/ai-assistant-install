
```bash
curl -fsSL https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml -o calico-operator.yaml
curl -fsSL https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml -o calico-custom-resources.yaml
```

```bash
kubectl apply -f calico-operator.yaml
kubectl apply -f calico-custom-resources.yaml
```

```bash
kubectl delete -f calico-operator.yaml
kubectl delete -f calico-custom-resources.yaml
```