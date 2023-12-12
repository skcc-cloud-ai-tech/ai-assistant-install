```bash
kubectl label --overwrite nodes codev-data0 nodetype=worker devicetype=cpu
kubectl label --overwrite nodes codev-gpu0 nodetype=worker devicetype=gpu
kubectl label --overwrite nodes codev-gpu1 nodetype=worker devicetype=gpu

kubectl label --overwrite nodes mini0-codev-ai nodetype=worker devicetype=gpu
kubectl label --overwrite nodes ubuntu nodetype=worker devicetype=cpu


node-role.kubernetes.io/control-plane: ""

kubectl taint nodes codev-data0 node-role.kubernetes.io/control-plane:NoSchedule-
```