```bash
helm upgrade --install postgresql \
  ./postgresql-ha \
  -n postgresql \
  -f values-postgresql.yaml


helm uninstall postgresql \
  -n postgresql
```