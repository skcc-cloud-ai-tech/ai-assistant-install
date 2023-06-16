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