
# AKS

See: https://learn.microsoft.com/en-us/azure/aks/azure-blob-csi?tabs=Blobfuse#before-you-begin

## Set persistence 

* Use `Blob`

```bash
$ az aks update --enable-blob-driver \
    -n aks-data-dev \
    -g rg-quickdrawai

Please make sure there is no open-source Blob CSI driver installed before enabling. (y/N): y
```

* Check if your cluster uses `managed identity`

See: https://learn.microsoft.com/en-us/azure/aks/use-managed-identity#bring-your-own-control-plane-managed-identity

```bash
$ az aks show \
    -n aks-data-dev \
    -g rg-quickdrawai \
    --query "servicePrincipalProfile"
{
  "clientId": "msi"
}
```

* Get `principalID`

```bash
$ az aks show \
    -n aks-data \
    -g rg-quickdrawai \
    --query "identity"
{
  "principalId": "<uuid4>",
  "tenantId": "<uuid4>",
  "type": "SystemAssigned",
  "userAssignedIdentities": null
}
```

* Add a role assignment

```bash
$ az role assignment create \
    --assignee <control-plane-identity-principal-id> \
    --role "Contributor" \
    --scope "<custom-resource-group-resource-id>"
az role assignment create \
    --assignee 56a5d3cc-6cee-40ca-aad7-5c64976486a2 \
    --role "Contributor" \
    --scope "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/MC_rg-quickdrawai_aks-data_eastus/providers/Microsoft.Network/networkSecurityGroups/aks-agentpool-28425015-nsg" \
    --scope "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-quickdrawai/providers/Microsoft.Network/virtualNetworks/vnet-quickdrawai"

```


```bash
az aks update \
    -g rg-quickdrawai \
    -n aks-data \
    --enable-managed-identity
# az identity create --name identity-az-data --resource-group myResourceGroup
```

# Set `allowlist` for sysctl in AKS

See: https://learn.microsoft.com/en-us/azure/aks/custom-node-configuration?tabs=linux-node-pools


* `linuxkubeletconfig.json`:

```json
{
 "cpuManagerPolicy": "static",
 "cpuCfsQuota": true,
 "cpuCfsQuotaPeriod": "200ms",
 "imageGcHighThreshold": 90,
 "imageGcLowThreshold": 70,
 "topologyManagerPolicy": "best-effort",
 "allowedUnsafeSysctls": [
//   "kernel.msg*",
//   "net.*"
    "vm.max_map_count"
],
 "failSwapOn": false
}
```

* `linuxosconfig.json`:

```json
{
 "transparentHugePageEnabled": "madvise",
 "transparentHugePageDefrag": "defer+madvise",
 "swapFileSizeMB": 1500,
 "sysctls": {
//   "netCoreSomaxconn": 163849,
//   "netIpv4TcpTwReuse": true,
//   "netIpv4IpLocalPortRange": "32000 60000"
    "vm.max_map_count": 262144
 }
}
```

```bash
# az aks nodepool add \
#     --no-wait \
#     --cluster-name aks-data \
#     --name workerpool \
#     --resource-group rg-quickdrawai \
#     --mode User \
#     --eviction-policy Delete \
#     --tags creator="youngju_kim" owner="youngju_kim" objective="사내chatgpt" \
#     --vnet-subnet-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-quickdrawai/providers/Microsoft.Network/virtualNetworks/vnet-quickdrawai/subnets/aks-data" \
#     --node-vm-size "Standard_D4as_v5" \
#     --labels nodetype=worker spot=true \
#     --enable-cluster-autoscaler \
#     --min-count 1 \
#     --max-count 5 \
#     --os-type Linux \
#     --os-sku Ubuntu \
#     --kubernetes-version "1.26.3" \
#     --max-pods 110 \
#     --priority Spot \
#     --spot-max-price -1.0 \
#     --node-osdisk-size 128 \
#     --node-osdisk-type Managed \
#     --linux-os-config linuxosconfig.json

az aks nodepool add \
    --no-wait \
    --cluster-name aks-data \
    --name workerpool \
    --resource-group rg-quickdrawai \
    --mode User \
    --eviction-policy Delete \
    --tags creator="youngju_kim" owner="youngju_kim" objective="사내chatgpt" \
    --vnet-subnet-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-quickdrawai/providers/Microsoft.Network/virtualNetworks/vnet-quickdrawai/subnets/aks-data" \
    --node-vm-size "Standard_D4as_v5" \
    --labels nodetype=worker spot=false \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 5 \
    --os-type Linux \
    --os-sku Ubuntu \
    --kubernetes-version "1.26.3" \
    --max-pods 110 \
    --priority Regular \
    --node-osdisk-size 128 \
    --node-osdisk-type Managed \
    --linux-os-config linuxosconfig.json
```

```bash
az aks nodepool update \
    --name spworkerpool \
    --cluster-name aks-data \
    --resource-group rg-quickdrawai \
    --kubelet-config ./linuxkubeletconfig.json
```

```yaml
kubectl create ns opensearch
kubectl -n opensearch apply -f - <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: statefulset-blob-nfs
  labels:
    app: nginx
spec:
  serviceName: statefulset-blob-nfs
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
        - name: statefulset-blob-nfs
          image: mcr.microsoft.com/oss/nginx/nginx:1.19.5
          volumeMounts:
            - name: persistent-storage
              mountPath: /mnt/blob
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: nginx
  volumeClaimTemplates:
    - metadata:
        name: persistent-storage
      spec:
        storageClassName: azureblob-nfs-premium
        accessModes: ["ReadWriteMany"]
        resources:
          requests:
            storage: 100Gi
EOF
```
