#!/bin/bash

# sudo bash -c 'echo "vm.max_map_count = 262144" >> /etc/sysctl.conf' && sudo sysctl -p

kubectl apply -f pvpvc

helm upgrade --install opensearch \
  ./opensearch-fsgroup \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-http.yaml

helm upgrade --install opensearch-dashboards \
  ./opensearch-dashboards \
  -n opensearch \
  --create-namespace \
  -f values-opensearch-dashboards-http.yaml

