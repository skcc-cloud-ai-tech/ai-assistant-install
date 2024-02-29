#!/bin/bash

kubectl apply -f pvpvc

helm upgrade -i qdrant \
  ./qdrant \
  -n qdrant \
  --create-namespace \
  -f values-qdrant.yaml
