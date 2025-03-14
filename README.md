

```bash
(cd ./terraform/; terraform init)
(cd ./terraform/; terraform apply)
```
1. Установить Tantos на машины
talosctl gen config --kubernetes-version 1.32.1 --with-secrets secrets.yaml talos-prod-01 https://192.168.14.50:6443 --config-patch @patch.yaml --force

talosctl machineconfig patch worker.yaml --patch @worker0.patch --output worker0.yaml
talosctl machineconfig patch controlplane.yaml --patch @cp0.patch --output cp0.yaml

talosctl apply-config --insecure -n 192.168.14.51 --file ./cp0.yaml
talosctl apply-config --insecure -n 192.168.14.61 --file ./worker0.yaml
talosctl bootstrap --nodes 192.168.14.51 --endpoints 192.168.14.51 --talosconfig=./talosconfig

talosctl kubeconfig ~/.kube/config --nodes 192.168.14.50 --endpoints 192.168.14.50 --talosconfig ./talosconfig

helm upgrade     --install     cilium     cilium/cilium     --version 1.16.5     --namespace kube-system     --values cilium/values.yaml
kubectl apply -f cilium/ippool.yaml
kubectl apply -f cilium/l2-announcement-policy.yaml

helm upgrade   --install   --namespace traefik   --create-namespace   traefik traefik/traefik   --values traefik/values.yaml

2. Сгенерировать конфиги
3. Задеплоить кластер
4. Поставить cilium
5. Поставить ArgoCD
```bash
(cd ./terraform/; terraform apply)
```
6. Добавить SSH ключ в ArgoCD

7. Настроить Traefik
    helm upgrade   --install   --namespace traefik   --create-namespace   traefik traefik/traefik   --values traefik/values.yaml