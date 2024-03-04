#!/bin/bash

kubectl create ns redis

kubectl apply -f pvpvc/pv.yaml
kubectl apply -f pvpvc/pvc.yaml

helm upgrade --install redis \
  ./redis \
  -n redis \
  --create-namespace \
  -f values-redis-kind.yaml

# helm -n redis uninstall redis
