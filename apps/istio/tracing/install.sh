#!/bin/bash

kubectl apply -f prometheus-istio-1.19-extra.yaml
kubectl apply -f grafana-istio-1.19-extra.yaml
kubectl apply -f jaeger-istio-1.19-extra.yaml

echo $RANDOM | md5sum | head -c 32; echo;

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kiali-signing-key-manual-token
  namespace: istio-system
  annotations:
    kubernetes.io/service-account.name: kiali
type: kubernetes.io/service-account-token
EOF

kubectl apply -f kiali-istio-1.19-extra.yaml
kubectl apply -f virtualservice.yaml