
```bash
kubectl -n opensearch create secret generic az-domain-keystore \
    --from-file=keystore=certs/vault-quickdraw-cert-quickdrawaidef16aee-6501-4456-9a0b-99a9e0f90f88-20230620.pfx
```