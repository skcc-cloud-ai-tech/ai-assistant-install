

```bash
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo update

helm search repo projectcalico
# NAME                            CHART VERSION   APP VERSION     DESCRIPTION                            
# projectcalico/tigera-operator   v3.27.0         v3.27.0         Installs the Tigera operator for Calico

helm pull projectcalico/tigera-operator \
  --version "v3.27.0" \
  --untar

```

* `tigera-operator/templates/tigera-operator/02-serviceaccount-tigera-operator.yaml`:

```yaml
kind: ServiceAccount
...
metadata:
  annotations:
    kubernetes.io/enforce-mountable-secrets: "true"
...
```

```bash
# helm upgrade --install calico \
#   ./tigera-operator \
#   -n calico-system \
#   --create-namespace \
#   -f values-calico.yaml

# helm upgrade --install calico \
#   ./tigera-operator \
#   -n calico-system \
#   --create-namespace \
#   -f values-calico-vxlan.yaml

helm upgrade --install calico \
  ./tigera-operator \
  -n calico-system \
  --create-namespace \
  -f values-calico-bgp.yaml

kubectl create ns calico-system
# kubectl -n calico-system apply -f ./calico-roles.yaml
helm upgrade --install calico \
  ./tigera-operator \
  -n calico-system \
  -f values-calico-bgp.yaml
kubectl apply -f ./calico-roles.yaml
```

```bash
$ Calico process is running.

IPv4 BGP status
+----------------+-------------------+-------+----------+-------------+
|  PEER ADDRESS  |     PEER TYPE     | STATE |  SINCE   |    INFO     |
+----------------+-------------------+-------+----------+-------------+
| 10.250.107.189 | node-to-node mesh | up    | 10:36:56 | Established |
| 10.250.107.192 | node-to-node mesh | up    | 10:36:56 | Established |
| 10.250.107.194 | node-to-node mesh | up    | 10:36:57 | Established |
| 10.250.107.191 | node-to-node mesh | up    | 10:37:16 | Established |
+----------------+-------------------+-------+----------+-------------+

IPv6 BGP status
No IPv6 peers found.
```

```bash
calicoctl create -f - <<EOF
apiVersion: projectcalico.org/v3
kind: BGPConfiguration
metadata:
  name: default
spec:
  # serviceClusterIPs:
  # - cidr: 10.96.0.0/12
  # - cidr: fd00:1234::/112
  # serviceExternalIPs:
  # # - cidr: 192.168.0.0/16
  # - cidr: 10.250.107.189/32
  # - cidr: 10.250.107.191/32
  # - cidr: 10.250.107.192/32
  # - cidr: 10.250.107.193/32
  # - cidr: 10.250.107.194/32
  serviceLoadBalancerIPs:
  - cidr: 10.250.107.189/32
  nodeToNodeMeshEnabled: false
EOF

```

```bash
$ sudo calicoctl node status

Calico process is running.

IPv4 BGP status
No IPv4 peers found.

IPv6 BGP status
No IPv6 peers found.
```

helm uninstall calico -n calico-system
```

rm ns-calico-system.json
kubectl get ns calico-system -o json > ns-calico-system.json
vim ns-calico-system.json  # "finalizers": []
curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://127.0.0.1:8001/api/v1/namespaces/calico-system/finalize
kubectl -n calico-system delete sa calico-cni-plugin
kubectl -n calico-system delete sa calico-node


ls /sys/class/net | grep cali | xargs -I{} sudo ip link delete "{}"

---
