# Milvus

```bash
helm repo add zilliztech https://zilliztech.github.io/milvus-helm
helm repo update

$ helm search repo zilliztech
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
zilliztech/milvus       4.1.15          2.3.5           Milvus is an open-source vector database built ...
zilliztech/minio        8.0.17          master          High Performance, Kubernetes Native Object Storage

helm pull zilliztech/milvus \
  --version "4.1.15" \
  --untar
```

* `milvus/charts/minio/values.yaml`:

```yaml
#replicas: 4
replicas: 2
```


```bash
helm upgrade -i milvus \
  ./milvus \
  -n milvus \
  --create-namespace \
  -f values-milvus.yaml
```

```bash
helm repo add zilliztech https://zilliztech.github.io/milvus-helm
helm repo update
```