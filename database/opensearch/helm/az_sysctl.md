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
az aks nodepool add \
    --name spworkerpool \
    --cluster-name aks-data \
    --resource-group rg-quickdraw \
    --kubelet-config ./linuxkubeletconfig.json
```