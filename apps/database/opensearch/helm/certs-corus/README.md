
```bash
kubectl -n opensearch create secret generic az-domain-keystore \
    --from-file=keystore=vault-quickdraw-cert-corus-ai45485fc0-1955-4696-a3be-0b5b9ecd7a27-20230703.pfx

```

Generate Keystore and Truststore with JAVA

```bash
keytool -keystore opensearch.keystore -genkey -alias coruskeystore

```