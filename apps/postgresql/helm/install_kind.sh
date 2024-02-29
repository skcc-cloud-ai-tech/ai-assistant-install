#!/bin/bash

kubectl apply -f pvpvc

kubectl create secret generic systemdb-cred \
  -n corus \
  --from-literal=username="$DB_USERNAME" \
  --from-literal=password="$DB_PASSWORD"

helm upgrade --install postgresql \
  ./postgresql-ha \
  -n postgresql \
  -f values-postgresql-kind.yaml
