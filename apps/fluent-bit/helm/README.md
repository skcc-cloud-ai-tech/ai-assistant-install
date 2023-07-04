# Fluent-bit with `helm`

## Installation

```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm search repo fluent/fluent-bit
helm pull fluent/fluent-bit \
    --version "0.34.1" \
    --untar


# Create a namespace
NAMESPACE="logging"
kubectl create namespace ${NAMESPACE}

# Create a secret to access Open Distro for OPENSEARCH: USERNAME & PASSWORD
kubectl create secret generic es-cred \
  -n ${NAMESPACE} \
  --from-literal=OPENSEARCH_USERNAME='xxx' \
  --from-literal=OPENSEARCH_PASSWORD='xxx'


helm upgrade --install fluent-bit \
  ./fluent-bit \
  --namespace ${NAMESPACE} \
  --create-namespace \
  --values=values-fluentbit.yaml \
  > upgrade_fluent-bit.log # > 2>&1
k -n ${NAMESPACE} rollout restart daemonset fluent-bit

```

```bash
# helm -n ${NAMESPACE} uninstall fluent-bit
```

## Set ExternalName for `fluent-bit`

```bash
kubectl -n ${NAMESPACE} apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: OPENSEARCH
spec:
  type: ExternalName
  # externalName: OPENSEARCH-opendistro-es-data-svc.OPENSEARCH.svc.cluster.local
  # externalName: OPENSEARCH-opendistro-es-client-service.OPENSEARCH.svc.cluster.local
  externalName:  opensearch.corus-ai.net
  ports:
  - port: 9200
    targetPort: 9200
    protocol: TCP
EOF
```
