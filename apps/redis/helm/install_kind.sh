#!/bin/bash

kubectl apply -f pvpvc

helm upgrade --install redis \
  ./redis \
  -n redis \
  --create-namespace \
  -f values-redis-kind.yaml
