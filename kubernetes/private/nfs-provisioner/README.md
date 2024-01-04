```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

helm search repo
# nfs-subdir-external-provisioner/nfs-subdir-exte...      4.0.18          4.0.2                           nfs-subdir-external-provisioner is an automatic...


helm pull nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --version "4.0.18" \
  --untar

helm upgrade --install nfs-subdir-external-provisioner \
    ./nfs-subdir-external-provisioner \
    -n corus \
    --create-namespace \
    -f values-nfs.yaml


helm uninstall -n corus nfs-subdir-external-provisioner 
```