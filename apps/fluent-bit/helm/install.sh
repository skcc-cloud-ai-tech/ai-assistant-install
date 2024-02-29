#!/bin/bash

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


helm upgrade --install fluent-bit \
  ./fluent-bit \
  --namespace logging \
  --create-namespace \
  --values=values-fluentbit-opensearch-http.yaml \
  > upgrade_fluent-bit.log # > 2>&1
k -n logging rollout restart daemonset fluent-bit

kubectl -n logging apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: OPENSEARCH
spec:
  type: ExternalName
  externalName:  opensearch-cluster-master.opensearch.svc.cluster.local
  ports:
  - port: 9200
    targetPort: 9200
    protocol: TCP
EOF