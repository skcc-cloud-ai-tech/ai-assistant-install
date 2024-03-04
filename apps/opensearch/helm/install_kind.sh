#!/bin/bash

# sudo bash -c 'echo "vm.max_map_count = 262144" >> /etc/sysctl.conf' && sudo sysctl -p


OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="admin"

kubectl create ns logging
kubectl create secret generic opensearch-cred \
  -n logging \
  --from-literal=username="$OPENSEARCH_USERNAME" \
  --from-literal=password="$OPENSEARCH_PASSWORD"

kubectl create secret generic es-cred \
  -n corus \
  --from-literal=username="$OPENSEARCH_USERNAME" \
  --from-literal=password="$OPENSEARCH_PASSWORD"


kubectl create ns opensearch

kubectl apply -f pvpvc/pv.yaml
# kubectl apply -f pvpvc/pvc.yaml  # use dynamic provisioning pvc

# Run in host, not the node of kind:
# > sysctl -w vm.max_map_count=262144
# > echo 'vm.max_map_count = 262144' >> /etc/sysctl.d/opensearch.conf && sysctl --system

helm upgrade --install opensearch \
  ./opensearch-fsgroup \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-http-kind.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-http-kind.yaml

# helm -n opensearch uninstall opensearch
# helm -n opensearch uninstall opensearch-dashboards
