
```bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```



```bash
# data disk mounted: /data

# Create a local cluster
# kind delete cluster -n local
# kind create cluster \
#   --name local \
#   --config kind-cluster-config.yaml

kind create cluster \
  --name local \
  --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        system-reserved: cpu=6,memory=12Gi
  extraPortMappings:
  - containerPort: 30000
    hostPort: 80
    listenAddress: "127.0.0.1"
    protocol: TCP
  extraMounts:
    - hostPath: /tmp/volumes
      containerPath: /volumes
    - hostPath: "$HOME/.ssl/SK_SSL.crt"
      containerPath: /usr/local/share/ca-certificates/SK_SSL.crt
# - role: worker
EOF

docker exec local-control-plane update-ca-certificates

kubectl label --overwrite nodes `kubectl get no -o jsonpath='{.items[0].metadata.name}'` nodetype=worker devicetype=cpu
# kubectl label --overwrite nodes `kubectl get no -o jsonpath='{.items[1].metadata.name}'` nodetype=worker devicetype=cpu

kubectl config current-context  # kind-local

# Install Istio
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system

helm upgrade --install istio-base \
    istio/base \
    --version "1.18.0" \
    -n istio-system

helm upgrade --install istio-istiod \
    istio/istiod \
    --version "1.18.0" \
    -n istio-system

helm upgrade --install istio-gateway \
    istio/gateway \
    --version "1.18.0" \
    -n istio-system \
    -f istio-values-kind.yaml \
    --wait


DB_USERNAME="corus_test"
DB_PASSWORD="corus_test"

kubectl create ns corus


helm upgrade --install systemdb \
  oci://registry-1.docker.io/bitnamicharts/postgresql \
  -n corus \
  --set global.postgresql.auth.username=$DB_USERNAME \
  --set global.postgresql.auth.password=$DB_PASSWORD \
  --set global.postgresql.auth.database=corus_backend \
  --set primary.persistence.enabled=false \
  --set readReplicas.persistence.enabled=false \
  --wait


az aks get-credentials --resource-group rg-quickdrawai --name aks-corus
# DB_USERNAME="$(kubectl -n corus get secrets systemdb-cred -o jsonpath='{.data.username}' | base64 -d)"
# DB_PASSWORD="$(kubectl -n corus get secrets systemdb-cred -o jsonpath='{.data.password}' | base64 -d)"
# OPENSEARCH_USERNAME="$(kubectl -n corus get secrets opensearch-cred -o jsonpath='{.data.username}' | base64 -d)"
# OPENSEARCH_PASSWORD="$(kubectl -n corus get secrets opensearch-cred -o jsonpath='{.data.password}' | base64 -d)"
OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="admin"
ECR_SECRET="$(kubectl -n corus get secrets az-ecr-cred -o yaml)"
LLM_SECRET="$(kubectl -n corus get secrets llm-endpoint-cred -o yaml)"


kubectl config use-context kind-local
kubectl create secret generic systemdb-cred \
  -n corus \
  --from-literal=username="$DB_USERNAME" \
  --from-literal=password="$DB_PASSWORD"

kubectl create secret generic es-cred \
  -n corus \
  --from-literal=username="$OPENSEARCH_USERNAME" \
  --from-literal=password="$OPENSEARCH_PASSWORD"


echo "$ECR_SECRET" | kubectl apply -f -
echo "$LLM_SECRET" | kubectl apply -f -

sudo kind load docker-image \
  --name test-cluster \


kubectl apply -f serviceaccount.yaml
kubectl apply -f systemdb-service.yaml
kubectl apply -f es-service.yaml
kubectl apply -f gateway.yaml
# kubectl apply -f llm-api-key-secret-example.yaml

kubectl apply -f corus-pv.yaml
kubectl apply -f corus-pvc.yaml

kubectl apply -f ../local/project_meta/embedding/embedding-pv.yaml
kubectl apply -f ../local/project_meta/embedding/embedding-pvc.yaml
kubectl apply -f ../local/project_meta/embedding/py-profiles.yaml
kubectl apply -f ../local/project_meta/embedding/deployment.yaml
# kubectl apply -f ../local/project_meta/embedding/service.yaml

kubectl apply -f ../local/project_meta/search/search-pv.yaml
kubectl apply -f ../local/project_meta/search/search-pvc.yaml
kubectl apply -f ../local/project_meta/search/py-profiles.yaml
kubectl apply -f ../local/project_meta/search/deployment.yaml
# kubectl apply -f ../local/project_meta/search/service.yaml


kubectl apply -f ../dev/backend/service.yaml
# kubectl apply -f ../dev/backend/py-profiles.yaml
kubectl apply -f ../local/backend/py-profiles.yaml
kubectl apply -f ../dev/backend/service.yaml
# kubectl apply -f ../dev/backend/deployment.yaml
kubectl apply -f ../local/backend/deployment.yaml
kubectl apply -f ../local/frontend

# kubectl apply -f ../dev/project_meta/embedding
# kubectl apply -f ../dev/project_meta/search

kubectl apply -f httpbin.yaml

```


```bash
docker pull <image>:<tag>
kind load docker-image \
  --name local \
  <image>:<tag>

```