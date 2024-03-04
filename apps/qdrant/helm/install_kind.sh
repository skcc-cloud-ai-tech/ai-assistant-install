#!/bin/bash

kubectl create ns qdrant

kubectl apply -f pvpvc/pv.yaml
kubectl apply -f pvpvc/pvc.yaml

helm upgrade -i qdrant \
  ./qdrant \
  -n qdrant \
  --create-namespace \
  -f values-qdrant-kind.yaml

# helm -n qdrant uninstall qdrant
