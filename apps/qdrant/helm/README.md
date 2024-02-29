# qdrant

```bash
helm repo add qdrant https://qdrant.to/helm
# helm repo add qdrant https://qdrant.github.io/qdrant-helm
helm repo update

$ helm search repo qdrant
NAME            CHART VERSION   APP VERSION     DESCRIPTION                                       
qdrant/qdrant   0.7.5           v1.7.3          Qdrant - Vector Database for the next generatio...

helm pull qdrant/qdrant \
  --version "0.7.5" \
  --untar

helm upgrade -i qdrant \
  ./qdrant \
  -n qdrant \
  --create-namespace \
  -f values-qdrant.yaml
```
