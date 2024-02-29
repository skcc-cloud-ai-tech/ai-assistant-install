#!/bin/bash

# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/kubectl

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# # For ARM64
# [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

mkdir -p /tmp/volumes

HOST_VOLUME=/data/kind_host_volume
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
    listenAddress: "0.0.0.0"
    # listenAddress: "127.0.0.1"
    protocol: TCP
  extraMounts:
    - hostPath: $HOST_VOLUME
      containerPath: /volume
    - hostPath: "$HOME/.ssl/SK_SSL.crt"
      containerPath: /usr/local/share/ca-certificates/SK_SSL.crt
# - role: worker
EOF

docker update --cpus=14 -m 28g --memory-swap -1 local-control-plane
kubectl label --overwrite nodes `kubectl get no -o jsonpath='{.items[0].metadata.name}'` nodetype=worker devicetype=cpu


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



DB_USERNAME="corus"
DB_PASSWORD="Quickdraw!"

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

REDIS_PASSWORD="Quickdraw!"
helm upgrade --install redis \
  oci://registry-1.docker.io/bitnamicharts/redis \
  -n corus \
  --set global.redis.password=$REDIS_PASSWORD \
  --set replica.replicaCount=0

kubectl create secret docker-registry acr-cred \
    --namespace corus \
    --docker-server="codevai.azurecr.io" \
    --docker-username="codevai" \
    --docker-password="Y6uL0zUOfDNE50G3PwNsTulk77HP9lc5nnotC43WaX+ACRA5rpNl"

kubectl create secret generic acr-cred-generic \
    --namespace corus \
    --from-literal=username='codevai' \
    --from-literal=password='Y6uL0zUOfDNE50G3PwNsTulk77HP9lc5nnotC43WaX+ACRA5rpNl'

az aks get-credentials --resource-group rg-quickdrawai --name aks-corus
LLM_SECRET="$(kubectl -n corus get secrets llm-endpoint-cred -o yaml)"
kubectl config use-context kind-local

echo "$LLM_SECRET" | kubectl apply -f -
kubectl create secret generic systemdb-cred \
  -n corus \
  --from-literal=username="$DB_USERNAME" \
  --from-literal=password="$DB_PASSWORD"

OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="admin"
kubectl create secret generic opensearch-cred \
  -n corus \
  --from-literal=username="$OPENSEARCH_USERNAME" \
  --from-literal=password="$OPENSEARCH_PASSWORD"

kubectl create secret generic es-cred \
  -n corus \
  --from-literal=username="$OPENSEARCH_USERNAME" \
  --from-literal=password="$OPENSEARCH_PASSWORD"


kubectl apply -f resources/serviceaccount.yaml
kubectl apply -f resources/systemdb-service.yaml
# kubectl apply -f resources/es-service.yaml
kubectl apply -f resources/gateway.yaml
# kubectl apply -f llm-api-key-secret-example.yaml

kubectl apply -f resources/corus-pv.yaml
kubectl apply -f resources/corus-pvc.yaml

# =========================================================

cd ~/git/ai-assistant-backend/k8s
kubectl apply -f local/backend/service.yaml
# kubectl apply -f local/backend/py-profiles.yaml
kubectl apply -f dev/backend/py-profiles.yaml
kubectl apply -f local/backend/service.yaml
# kubectl apply -f local/backend/deployment.yaml
kubectl apply -f local/backend/deployment.yaml
kubectl apply -f local/frontend

kubectl apply -f dev/backend/virtualservice.yaml
