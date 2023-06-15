# Opensearch: `helm`

See: https://github.com/opensearch-project/helm-charts


## Pre-requisite

See: https://learn.microsoft.com/en-us/azure/aks/azure-blob-csi?tabs=Blobfuse#before-you-begin

* Use `Blob`

```bash
$ az aks update --enable-blob-driver \
    -n aks-data \
    -g rg-quickdrawai

Please make sure there is no open-source Blob CSI driver installed before enabling. (y/N): y
```

* Check if your cluster uses `managed identity`

```bash
$ az aks show \
    -n aks-data \
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

## Install

```bash
helm repo add opensearch https://opensearch-project.github.io/helm-charts/
helm repo update
```

```bash
$ helm search repo opensearch
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                           
opensearch/opensearch                   2.13.1          2.8.0           A Helm chart for OpenSearch           
opensearch/opensearch-dashboards        2.11.1          2.8.0           A Helm chart for OpenSearch Dashboards
```

```bash
helm pull opensearch/opensearch \
  --version "2.13.1" \
   --untar

helm pull opensearch/opensearch-dashboards \
  --version "2.11.1" \
  --untar
```


```bash
helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards.yaml
```