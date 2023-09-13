
```bash
az network bastion ssh --auth-type
                       [--ids]
                       [--name]
                       [--resource-group]
                       [--resource-port]
                       [--ssh-key]
                       [--subscription]
                       [--target-ip-address]
                       [--target-resource-id]
                       [--username]

az network bastion ssh \
  --subscription "f7137354-a978-47b6-8463-a82940478c01" \
  --resource-group "rg-corus" \
  --name "vnet-corus-prd-Bastion" \
  --auth-type "ssh-key" \
  --ssh-key "~/.ssh/bastion-corus-prd_key.pem"

az account set --subscription f7137354-a978-47b6-8463-a82940478c01 && \
  az network bastion ssh --name "vnet-quickdrawai-bastion" --resource-group "rg-quickdrawai" --target-resource-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-quickdrawai/providers/Microsoft.Compute/virtualMachines/bastion-quickdraw" --auth-type "ssh-key" --username quickdraw --ssh-key "~/.ssh/bastion-quickdraw_key.pem"

az network bastion ssh \
    --name "vnet-corus-prd-Bastion" \
    --resource-group "rg-corus" \
    --target-resource-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-corus/providers/Microsoft.Compute/virtualMachines/bastion-corus-prd" \
    --auth-type "ssh-key" \
    --username corus \
    --ssh-key "~/.ssh/bastion-corus-prd_key.pem"


az network bastion ssh \
  --name "<BastionName>" \
  --resource-group "<ResourceGroupName>" \
  --target-resource-id "<VMResourceId>" \
  --auth-type "ssh-key" \
  --username "<Username>" \
  --ssh-key "<Filepath>"


az network bastion ssh \
  --name "bastion-vnet-corus-prd" \
  --resource-group "rg-corus" \
  --target-resource-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-corus/providers/Microsoft.Compute/virtualMachines/bastion-corus-prd" \
  --auth-type "ssh-key" \
  --username "corus" \
  --ssh-key "~/.ssh/bastion-corus-prd_key.pem"


az network bastion ssh \
  --name "<BastionName>" \
  --resource-group "<ResourceGroupName>" \
  --target-resource-id "<VMResourceId or VMSSInstanceResourceId>" \
  --auth-type "AAD"

az network bastion ssh \
  --name "bastion-vnet-corus-prd" \
  --resource-group "rg-corus" \
  --target-resource-id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-corus/providers/Microsoft.Compute/virtualMachines/bastion-corus-prd" \
  --auth-type "AAD"

az network bastion ssh --name "<BastionName>" --resource-group "<ResourceGroupName>" --target-resource-id "<VMResourceId or VMSSInstanceResourceId>" --auth-type "AAD"

az network bastion show \
  --ids "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-corus/providers/Microsoft.Network/bastionHosts/vnet-corus-prd-Bastion" \
  --name "vnet-corus-prd-Bastion" \
  --resource-group "rg-corus" \
  --subscription "f7137354-a978-47b6-8463-a82940478c01"
az network bastion show [--ids]
                        [--name]
                        [--resource-group]
                        [--subscription]


az network bastion delete [--ids]
                          [--name]
                          [--no-wait {0, 1, f, false, n, no, t, true, y, yes}]
                          [--resource-group]
                          [--subscription]


az ssh vm \
  --resource-group "rg-corus" \
  --name "bastion-corus-prd" \
  --local-user "corus" \
  --private-key-file ".ssh/bastion-corus-prd_key.pem"


```

```bash

AKS_RESOURCE_ID=$(az aks show \
    --resource-group "rg-corus" \
    --name "aks-corus-prd" \
    --query id -o tsv)
echo $AKS_RESOURCE_ID

CORUS_PRD_ADMIN_ID=$(az ad group create \
  --display-name corus-prd-admin \
  --mail-nickname corus-prd-admin \
  --query id -o tsv)


CORUS_PRD_ADMIN_ID=$(az ad group create \
  --display-name corus-prd-admin \
  --mail-nickname corus-prd-admin \
  --query id -o tsv)


CORUS_PRD_ADMIN_ID=$(az ad group show \
  --group corus-prd-admin \
  --query id -o tsv)
echo $CORUS_PRD_ADMIN_ID

# See: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
## Ascending
# az role assignment create \
#   --role "Azure Kubernetes Service Cluster Admin Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment create \
#   --role "Azure Kubernetes Service Cluster User Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment create \
#   --role "Azure Kubernetes Service Contributor Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment create \
#   --role "Azure Kubernetes Service RBAC Admin" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment create \
#   --role "Azure Kubernetes Service RBAC Reader" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment create \
#   --role "Azure Kubernetes Service RBAC Writer" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

ACCOUNT_UPN=$(az account show \
  --query user.name -o tsv)
ACCOUNT_ID=$(az ad user show \
  --id $ACCOUNT_UPN \
  --query id -o tsv)
CORUS_PRD_ADMIN_ID=$ACCOUNT_ID

# az role assignment create \
#   --role "Azure Kubernetes Service RBAC Cluster Admin" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

cat << EOF > ./role-definition.json
{
    "name": "Azure Kubernetes Service Cluster Admin - FullAccess2",
    "description": "Lets you manage all resources in the cluster.",
    "assignableScopes": [
        "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
    ],
    "permissions": [
        {
            "actions": [
                "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
                "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action",
                "Microsoft.ContainerService/managedClusters/runcommand/action",
                "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
                "Microsoft.ContainerService/managedClusters/read",
                "Microsoft.ContainerService/managedClusters/write",
                "Microsoft.Resources/deployments/*",
                "Microsoft.Authorization/*/read",
                "Microsoft.Resources/subscriptions/operationresults/read",
                "Microsoft.Resources/subscriptions/read",
                "Microsoft.Resources/subscriptions/resourceGroups/read",
                "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action"
            ],
            "notActions": [],
            "dataActions": [
                "Microsoft.ContainerService/managedClusters/*"
            ],
            "notDataActions": []
        }
    ]
}
EOF

az role definition create --role-definition role-definition.json

az role assignment create \
  --role "Azure Kubernetes Service Cluster Admin - FullAccess" \
  --assignee $CORUS_PRD_ADMIN_ID \
  --scope $AKS_RESOURCE_ID


# az role assignment delete \
#   --role "Azure Kubernetes Service RBAC Admin" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment delete \
#   --role "Azure Kubernetes Service Contributor Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment delete \
#   --role "Azure Kubernetes Service Cluster User Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az role assignment delete \
#   --role "Azure Kubernetes Service Cluster Admin Role" \
#   --assignee $CORUS_PRD_ADMIN_ID \
#   --scope $AKS_RESOURCE_ID

# az aks get-credentials --resource-group "rg-corus" --name "aks-corus-prd" --admin

AKS_RESOURCE_ID=$(az aks show \
    --resource-group "rg-corus" \
    --name "aks-corus-prd" \
    --query id -o tsv)
echo $AKS_RESOURCE_ID


cat << EOF > ./internal-lb-role-definition.json
{
    "name": "Azure Kubernetes Create Internal Load Balancer",
    "description": "Lets you manage all resources in the cluster.",
    "assignableScopes": [
        "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
    ],
    "permissions": [
        {
            "actions": [
                "Microsoft.Network/virtualNetworks/subnets/read",
                "Microsoft.Network/virtualNetworks/subnets/join/action"
            ],
            "notActions": [],
            "dataActions": [],
            "notDataActions": []
        }
    ]
}
EOF

az role definition create --role-definition internal-lb-role-definition.json

VNET_ID=$(az network vnet show \
  --name "vnet-corus-prd" \
  --resource-group "rg-corus" \
  --query id -o tsv)

AKS_OBJECT_ID=$(az aks show \
    --resource-group "rg-corus" \
    --name "aks-corus-prd" \
    --query identity.principalId -o tsv)
echo $AKS_OBJECT_ID


az role assignment create \
  --role "Azure Kubernetes Create Internal Load Balancer" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $VNET_ID
#   --assignee $AKS_RESOURCE_ID \

```


```bash
cat << EOF > ./linuxkubeletconfig.json
{
    "cpuManagerPolicy": "static",
    "cpuCfsQuota": true,
    "cpuCfsQuotaPeriod": "200ms",
    "imageGcHighThreshold": 90,
    "imageGcLowThreshold": 70,
    "topologyManagerPolicy": "best-effort",
    "allowedUnsafeSysctls": [
       "vm.max_map_count"
   ],
    "failSwapOn": false
}
EOF

cat << EOF > ./linuxosconfig.json
{
    "sysctls": {
       "vmMaxMapCount": 262144
    }
}
EOF

az aks nodepool add \
    --no-wait \
    --cluster-name aks-corus-prd \
    --name workersdata \
    --resource-group rg-corus \
    --mode User \
    --eviction-policy Delete \
    --tags creator="youngju_kim" profile="prd" project="ai-coding" \
    --node-vm-size "Standard_D8ds_v5" \
    --labels nodetype=worker devicetype=cpu-data \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3 \
    --os-type Linux \
    --os-sku Ubuntu \
    --kubernetes-version "1.26.3" \
    --max-pods 110 \
    --priority Regular \
    --node-osdisk-size 256 \
    --node-osdisk-type Managed \
    --linux-os-config linuxosconfig.json
    
    
# az aks nodepool update \
#     --name workersdata \
#     --cluster-name aks-corus-prd \
#     --resource-group rg-corus \
#     --kubelet-config ./linuxkubeletconfig.json
```


```bash
az aks update --enable-blob-driver \
    -n aks-corus-prd \
    -g rg-corus

```

```bash
kubectl create namespace istio-system

helm upgrade --install istio-base \
    ./base \
    -n istio-system \
  -f values-base.yaml

helm upgrade --install istio-istiod \
    ./istiod \
    -n istio-system \
  -f values-istiod.yaml \
  --wait


helm upgrade --install istio-gateway \
    ./gateway \
    -n istio-system \
    --create-namespace \
  -f values-gateway-aks-internal.yaml \
  --wait

```

```bash

STORAGE_KEY=$(az storage account keys list \
  --resource-group "rg-corus" \
  --account-name "storagecorusprd" \
  --query "[0].value" -o tsv)

kubectl create secret generic \
  corus-fs-secret \
  --namespace corus \
  --from-literal=azurestorageaccountname=storagecorusprd \
  --from-literal=azurestorageaccountkey=$STORAGE_KEY

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: corus-fs-secret
  namespace: corus
type: Opaque
stringData:
  azurestorageaccountname: storagecorusprd
  azurestorageaccountkey: 'JQjmUcUCEykGO0xFaxsU4WvPEqpIte5TFzQG1b2N0S3Uc/dQd7a7n0TxXkiOddytpiu7YGJxPsfn+AStp/b9bQ=='
EOF

kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: private-azurefile-csi-premium
provisioner: file.csi.azure.com
allowVolumeExpansion: true
parameters:
  resourceGroup: rg-corus
  storageAccount: corusstorageprd
  server: storagecorusprd.file.core.windows.net
  skuName: Premium_ZRS
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=0
  - gid=0
  - mfsymlinks
  - cache=strict  # https://linux.die.net/man/8/mount.cifs
  - nosharesock  # reduce probability of reconnect race
  - actimeo=30  # reduce latency for metadata-heavy workload
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: corus-file-storage
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: azurefile-csi-premium
  mountOptions:
    - dir_mode=0777
    - file_mode=0777
    # - uid=1000
    # - gid=1000
    # - mfsymlinks
    # - nobrl
  azureFile:
    secretName: corus-fs-secret
    shareName: corus-fs
    readOnly: false
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: corus-file-storage-claim
  namespace: corus
spec:
  accessModes:
    - ReadOnlyMany  # access mode 
  storageClassName: azurefile-csi-premium
  volumeName: corus-file-storage
  resources:
    requests:
      storage: 10Gi
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: embedding-file-storage
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: azurefile-csi-premium
  mountOptions:
    - dir_mode=0777
    - file_mode=0777
    # - uid=1000
    # - gid=1000
    # - mfsymlinks
    # - nobrl
  azureFile:
    secretName: corus-fs-secret
    shareName: corus-fs
    readOnly: false
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: embedding-file-storage-claim
  namespace: corus
spec:
  accessModes:
    - ReadOnlyMany  # access mode 
  storageClassName: azurefile-csi-premium
  volumeName: embedding-file-storage
  resources:
    requests:
      storage: 10Gi
EOF


kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: search-file-storage
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: azurefile-csi-premium
  mountOptions:
    - dir_mode=0777
    - file_mode=0777
    # - uid=1000
    # - gid=1000
    # - mfsymlinks
    # - nobrl
  azureFile:
    secretName: corus-fs-secret
    shareName: corus-fs
    readOnly: false
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: search-file-storage-claim
  namespace: corus
spec:
  accessModes:
    - ReadOnlyMany  # access mode 
  storageClassName: azurefile-csi-premium
  volumeName: search-file-storage
  resources:
    requests:
      storage: 10Gi
EOF

```


```bash

kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: istio-corus-gateway
  namespace: istio-system
spec:
  selector:
    # app: istio-gateway
    istio: gateway
  servers:
  - hosts:
    - '*'
    - 'codev.skcc.com'
    port:
      number: 80
      name: http
      protocol: HTTP
  # - port:
  #     number: 443
  #     name: https
  #     protocol: HTTPS
  #   tls:
  #     mode: SIMPLE
  #     serverCertificate: /etc/istio/ingressgateway-certs/tls.crt
  #     privateKey: /etc/istio/ingressgateway-certs/tls.key
  #   hosts:
  #   - dev.api.storefront-demo.com
  #   - test.api.storefront-demo.com
  #   - uat.api.storefront-demo.com
---

apiVersion: v1
kind: Service
metadata:
  name: corus-backend
  namespace: corus
spec:
  selector:
    app: corus-backend
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: vs-corus-backend
  namespace: corus
spec:
  hosts:
  - '*'
#   - 'corus-backend.corus.svc.cluster.local'
#   - 'codev.skcc.com'
  gateways:
  - istio-system/istio-corus-gateway
  # - mesh # applies to all the sidecars in the mesh
  http:
  - match:
    # - headers:
    #     cookie:
    #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
    - uri:
        prefix: /api/corus/backend/
    - uri:
        prefix: /api/corus/backend
    # - uri:
    #     prefix: /app/
    # - uri:
    #     prefix: /app
    rewrite:
      uri: "/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
  # - match:
  #   # - headers:
  #   #     cookie:
  #   #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
  #   - uri:
  #       prefix: /api/corus/backend/dashboard/
  #   - uri:
  #       prefix: /api/corus/backend/dashboard
  #   # - uri:
  #   #     prefix: /app/
  #   # - uri:
  #   #     prefix: /app
  #   rewrite:
  #     uri: "/dashboard/"
  #   route:
  #   - destination:
  #       port:
  #         number: 8000
  #       host: corus-backend.corus.svc.cluster.local
  - match:
    - uri:
        prefix: /dashboard/
    - uri:
        prefix: /dashboard
    rewrite:
      uri: "/dashboard/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
  - match:
    - uri:
        prefix: /admin/
    - uri:
        prefix: /admin
    rewrite:
      uri: "/dashboard/admin/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
EOF
```

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: vs-corus-backend
  namespace: corus
spec:
  hosts:
  - '*'
#   - 'corus-backend.corus.svc.cluster.local'
#   - 'codev.skcc.com'
  gateways:
  - istio-system/istio-corus-gateway
  # - mesh # applies to all the sidecars in the mesh
  http:
  - match:
    # - headers:
    #     cookie:
    #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
    - uri:
        prefix: /api/corus/backend/
    - uri:
        prefix: /api/corus/backend
    # - uri:
    #     prefix: /app/
    # - uri:
    #     prefix: /app
    rewrite:
      uri: "/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
  # - match:
  #   # - headers:
  #   #     cookie:
  #   #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
  #   - uri:
  #       prefix: /api/corus/backend/dashboard/
  #   - uri:
  #       prefix: /api/corus/backend/dashboard
  #   # - uri:
  #   #     prefix: /app/
  #   # - uri:
  #   #     prefix: /app
  #   rewrite:
  #     uri: "/dashboard/"
  #   route:
  #   - destination:
  #       port:
  #         number: 8000
  #       host: corus-backend.corus.svc.cluster.local
  - match:
    - uri:
        prefix: /dashboard/
    - uri:
        prefix: /dashboard
    rewrite:
      uri: "/dashboard/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
  - match:
    - uri:
        prefix: /admin/
    - uri:
        prefix: /admin
    rewrite:
      uri: "/dashboard/admin/"
    route:
    - destination:
        port:
          number: 8000
        host: corus-backend.corus.svc.cluster.local
  - match:
    - uri:
        prefix: /api/embedding/backend/
    - uri:
        prefix: /api/embedding/backend
    rewrite:
      uri: /
    route:
    - destination:
        host: ai-corus-embedding.corus.svc.cluster.local
        port:
          number: 8090
  - match:
    - uri:
        prefix: /api/search/backend/
    - uri:
        prefix: /api/search/backend
    rewrite:
      uri: /
    route:
    - destination:
        host: ai-corus-search.corus.svc.cluster.local
        port:
          number: 8000
  - match:
    # - headers:
    #     cookie:
    #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
    - uri:
        prefix: /
    # - uri:
    #     prefix: /app/
    # - uri:
    #     prefix: /app
    rewrite:
      uri: "/"
    route:
    - destination:
        port:
          number: 3000
        host: corus-frontend.corus.svc.cluster.local

```


---

# Opensearch

```bash


cat << EOF > ./blob-storage-role-definition.json
{
    "name": "Azure Kubernetes StorageClass Manage Blob Storage",
    "description": "Create Blob PV/PVC in the cluster.",
    "assignableScopes": [
        "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
    ],
    "permissions": [
        {
            "actions": [
                "Microsoft.Storage/*/read",
                "Microsoft.Storage/storageAccounts/*",
                "Microsoft.Storage/storageAccounts/blobServices/containers/read",
                "Microsoft.Storage/storageAccounts/blobServices/containers/write",
                "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
                "Microsoft.Storage/storageAccounts/listKeys/action"
            ],
            "notActions": [],
            "dataActions": [
                "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
                "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
                "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete"
            ],
            "notDataActions": []
        }
    ]
}
EOF

# "assignableScopes": [
#         "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
#     ],
cat << EOF > ./file-storage-role-definition.json
{
    "name": "Azure Kubernetes StorageClass Manage Files",
    "description": "Create File PV/PVC in the cluster.",
    "assignableScopes": [
        "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
    ],
    "permissions": [
        {
            "actions": [
                "Microsoft.Storage/storageAccounts/fileServices/read",
                "Microsoft.Storage/storageAccounts/fileServices/write",
                "Microsoft.Storage/storageAccounts/fileServices/shares/read",
                "Microsoft.Storage/storageAccounts/fileServices/shares/write"
            ],
            "notActions": [],
            "dataActions": [
                "Microsoft.Storage/storageAccounts/fileServices/fileshares/files/read",
                "Microsoft.Storage/storageAccounts/fileServices/fileshares/files/write",
                "Microsoft.Storage/storageAccounts/fileServices/fileshares/files/delete",
                "Microsoft.Storage/storageAccounts/fileServices/fileshares/files/modifypermissions/action"
            ],
            "notDataActions": []
        }
    ]
}
EOF

az role definition create --role-definition file-storage-role-definition.json

az role definition delete \
  --name "Azure Kubernetes StorageClass Manage Blob Storage"

az role definition delete \
  --name "Azure Kubernetes StorageClass Manage Files"

az role definition list \
  --name "Azure Kubernetes StorageClass Manage Files"

# cat << EOF > ./blob-storage-role-definition.json
# {
#     "id": "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/providers/Microsoft.Authorization/roleDefinitions/4d277f2a-fbf7-456c-a221-37ad7e1619da",
#     "roleName": "Azure Kubernetes StorageClass Manage Blob Storage",
#     "description": "Create Blob PV/PVC in the cluster.",
#     "assignableScopes": [
#         "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
#     ],
#     "permissions": [
#         {
#             "actions": [
#                 "*"
#             ],
#             "notActions": [],
#             "dataActions": [
#                 "*"
#             ],
#             "notDataActions": []
#         }
#     ]
# }
# EOF

# az role definition update \
#   --role-definition blob-storage-role-definition.json


SC_ID=$(az storage account show \
  --name "storagecorusprd" \
  --resource-group "rg-corus" \
  --query id -o tsv)

SC_BLOB_ID=$(az storage account blob-service-properties show \
  --account-name "storagecorusprd" \
  --resource-group "rg-corus" \
  --query id -o tsv)

SC_FILE_ID=$(az storage account file-service-properties show \
  --account-name "storagecorusprd" \
  --resource-group "rg-corus" \
  --query id -o tsv)

SC_FILE_SHARE_ID="${SC_FILE_ID}/shares"

AKS_OBJECT_ID=$(az aks show \
    --resource-group "rg-corus" \
    --name "aks-corus-prd" \
    --query identity.principalId -o tsv)
echo $AKS_OBJECT_ID


az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $SC_BLOB_ID

az role assignment create \
  --role "Reader and Data Access" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $SC_BLOB_ID

# az role assignment create \
#   --role "Azure Kubernetes StorageClass Manage Files" \
#   --assignee-object-id $AKS_OBJECT_ID \
#   --assignee-principal-type "ServicePrincipal" \
#   --scope $SC_FILE_ID

# SC_FILE_SHARE_ID="${SC_FILE_ID}/shares"
# az role assignment create \
#   --role "Azure Kubernetes StorageClass Manage Files" \
#   --assignee-object-id $AKS_OBJECT_ID \
#   --assignee-principal-type "ServicePrincipal" \
#   --scope $SC_FILE_SHARE_ID


az role assignment create \
  --role "Azure Kubernetes StorageClass Manage Files" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $SC_FILE_ID

# az role assignment create \
#   --role "Storage File Data Privileged Contributor" \
#   --assignee-object-id $AKS_OBJECT_ID \
#   --assignee-principal-type "ServicePrincipal" \
#   --scope $SC_FILE_ID

# az role assignment create \
#   --role "Storage File Data SMB Share Elevated Contributor" \
#   --assignee-object-id $AKS_OBJECT_ID \
#   --assignee-principal-type "ServicePrincipal" \
#   --scope $SC_FILE_ID

# az role assignment create \
#   --role "Storage Blob Data Contributor" \
#   --assignee-object-id $AKS_OBJECT_ID \
#   --assignee-principal-type "ServicePrincipal" \
#   --scope $SC_ID

az role assignment create \
  --role "Reader and Data Access" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $SC_ID

 az role assignment list \
   --scope $SC_FILE_ID

az role assignment delete \
  --id "/subscriptions/f7137354-a978-47b6-8463-a82940478c01/resourceGroups/rg-corus/providers/Microsoft.Storage/storageAccounts/storagecorusprd/fileServices/default/providers/Microsoft.Authorization/roleAssignments/afe2db14-09f6-4480-bb50-be22e10212ad"

```

```bash

kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: opensearch-azurefile-csi-premium
provisioner: file.csi.azure.com
allowVolumeExpansion: true
parameters:
  resourceGroup: rg-corus
  storageAccount: storagecorusprd
  server: storagecorusprd.file.core.windows.net
  skuName: Premium_ZRS
reclaimPolicy: Retain  # Delete
volumeBindingMode: Immediate
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=1000
  - gid=1000
  - mfsymlinks
  - cache=strict  # https://linux.die.net/man/8/mount.cifs
  - nosharesock  # reduce probability of reconnect race
  - actimeo=30  # reduce latency for metadata-heavy workload
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: opensearch-azureblob-fuse-premium
provisioner: blob.csi.azure.com
allowVolumeExpansion: true
parameters:
  resourceGroup: rg-corus
  storageAccount: storagecorusprd
  skuName: Premium_ZRS
reclaimPolicy: Retain  # Delete
volumeBindingMode: Immediate
mountOptions:
- -o allow_other
- --file-cache-timeout-in-seconds=120
- --use-attr-cache=true
- --cancel-list-on-mount-seconds=10
- -o attr_timeout=120
- -o entry_timeout=120
- -o negative_timeout=120
- --log-level=LOG_WARNING
- --cache-size-mb=1000
- -o uid=1000
- -o gid=1000

---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: opensearch-azureblob-nfs-premium
provisioner: blob.csi.azure.com
allowVolumeExpansion: true
parameters:
  protocol: nfs
  resourceGroup: rg-corus
  storageAccount: storagecorusprd
  skuName: Premium_ZRS
reclaimPolicy: Retain  # Delete
volumeBindingMode: Immediate
mountOptions: []

EOF

```

```bash
kubectl create namespace opensearch
helm upgrade --install opensearch \
  ./opensearch \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-http.yaml


helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-http.yaml


kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: vs-opensearch
  namespace: opensearch
spec:
  hosts:
  # - '*.opensearch.svc.cluster.local'
  - '*'
  gateways:
  - istio-system/istio-corus-gateway
  # - mesh # applies to all the sidecars in the mesh
  http:
  - match:
    # - headers:
    #     cookie:
    #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
    - uri:
        prefix: /api/opensearch/engine/
    - uri:
        prefix: /api/opensearch/engine
    rewrite:
      uri: "/"
    route:
    - destination:
        port:
          number: 9200
        host: opensearch-cluster-master-headless.opensearch.svc.cluster.local
  - match:
    # - headers:
    #     cookie:
    #       regex: "^(.*?;)?(user=dev-123)(;.*)?"
    - uri:
        prefix: /api/opensearch/dashboard/
    - uri:
        prefix: /api/opensearch/dashboard
    # rewrite:
    #   uri: "/"
    route:
    - destination:
        port:
          number: 5601
        host: opensearch-dashboards.opensearch.svc.cluster.local
EOF
```


```bash

kubectl create namespace logging
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  labels:
    app/group: corus
  name: opensearch-cred
  namespace: logging
type: Opaque
stringData:
  username: "admin"
  password: "admin"
EOF


helm upgrade --install fluent-bit \
  ./fluent-bit \
  --namespace logging \
  --create-namespace \
  --values=values-fluentbit-opensearch-http.yaml

```

```bash
# See: https://learn.microsoft.com/ko-kr/azure/vpn-gateway/openvpn-azure-ad-tenant

172.32.0.0/26

vpn-point-public-ip

TENANT_ID="d13053b8-7b0d-44bd-9c1e-feb48cae4398"
d13053b8-7b0d-44bd-9c1e-feb48cae4398

Tenant="https://login.microsoftonline.com/${TENANT_ID}"
https://login.microsoftonline.com/d13053b8-7b0d-44bd-9c1e-feb48cae4398/

Audience=`Azure VPN` Application_ID
41b23e61-6c1e-4545-b367-cd054e0ed4b4

# `/` must be appended!
Issuer="https://sts.windows.net/${TENANT_ID}/"
https://sts.windows.net/d13053b8-7b0d-44bd-9c1e-feb48cae4398/


# Azure VPN Client
https://aka.ms/azvpnclientdownload


cat << EOF > ./file-storage-role-definition.json
{
    "properties": {
        "roleName": "Azure Network - Download AzureVPN Client Info",
        "description": "Azure Network - Download AzureVPN Client and Connection Info",
        "assignableScopes": [
            "/subscriptions/f7137354-a978-47b6-8463-a82940478c01"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.Network/p2sVpnGateways/read",
                    "Microsoft.Network/p2sVpnGateways/generatevpnprofile/action"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
EOF

az role definition create --role-definition file-storage-role-definition.json

az network vnet-gateway show \
  -g "rg-corus" \
  -n "vpn-corus-prd" \
  --query id -o tsv




az role assignment create \
  --role "Reader and Data Access" \
  --assignee-object-id $AKS_OBJECT_ID \
  --assignee-principal-type "ServicePrincipal" \
  --scope $SC_ID

```


```bash
security-test-01@SKOpenAI.onmicrosoft.com   정보보호팀_테스트계정1
security-test-02@SKOpenAI.onmicrosoft.com   정보보호팀_테스트계정2
security-test-03@SKOpenAI.onmicrosoft.com   정보보호팀_테스트계정3
...
```

---

Application Gateway - TLS Termination

See:
* Base: https://learn.microsoft.com/ko-kr/azure/application-gateway/configure-application-gateway-with-private-frontend-ip
* TLS Termination with pfx in Key Vault:
  * https://learn.microsoft.com/ko-kr/azure/application-gateway/key-vault-certs
  * https://learn.microsoft.com/ko-kr/azure/application-gateway/configure-key-vault-portal?source=recommendations






```bash
openssl pkcs12 \
  -nodes
  -in vault-quickdraw-cert-corus-ai45485fc0-1955-4696-a3be-0b5b9ecd7a27-20230912.pfx \
  -out corus-ai.net.pem \

openssl pkcs12 \
  -export \
  -in corus-ai.net.pem \
  -out corus-ai.net.pfx \

```

In Bastion VM:

```bash
az keyvault secret show \
  --vault-name vault-corus \
  --name corus-ai-net-imported


az keyvault secret list-versions \
  --id https://vault-corus.vault.azure.net/secrets/corus-ai-net-imported/b8a380d2e5064743adfab56451d64752
  --vault-name vault-corus \
  --name corus-ai-net-imported

```

```powershell
> Get-AzKeyVaultSecret -VaultName "vault-corus" -Name "corus-ai-net-imported"

Vault Name   : vault-corus
Name         : corus-ai-net-imported
Version      : xxxxxxxxxx
Id           : https://vault-corus.vault.azure.net:443/secrets/corus-ai-net-imported/xxxxxxxxxx
Enabled      : True
Expires      : 7/3/2024 7:45:38 AM
Not Before   : 7/3/2023 7:45:38 AM
Created      : 9/12/2023 1:20:35 AM
Updated      : 9/12/2023 1:20:35 AM
Content Type : application/x-pkcs12
Tags         : 

#secretId = $secret.Id.Replace($secret.Version, "")
```


Upload a Bastion SSH Key to Azure Key Vault as a Secret

```bash
az keyvault secret set \
   --vault-name vault-corus \
   --name bastion-corus-prd-key \
   --file ~/.ssh/bastion-corus-prd_key.pem \
   --description 'SSH Key for Bastion'
   --encoding ascii \
```