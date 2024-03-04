#!/bin/bash

kubectl create ns postgresql

kubectl apply -f pvpvc/pv.yaml
kubectl apply -f pvpvc/pvc.yaml

# HOST_VOLUME=/var/tmp/kind_host_volume
# sudo chown -R 1001:0 $HOST_VOLUME/postgresql
# sudo chown -R nobody:nogroup $HOST_VOLUME/postgresql

kubectl create ns corus
kubectl create secret generic systemdb-cred \
  -n corus \
  --from-literal=username="$DB_USERNAME" \
  --from-literal=password="$DB_PASSWORD"

helm upgrade --install postgresql \
  ./postgresql-ha \
  -n postgresql \
  -f values-postgresql-kind.yaml

# helm -n postgresql uninstall postgresql
