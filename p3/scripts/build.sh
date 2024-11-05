#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi
k3d cluster create achiu-au-iot
kubectl create namespace argocd
kubectl create namespace dev
echo  "Installing argocd"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 4
echo "Waiting for condition to be ready for pods"
kubectl wait -n argocd --for=condition=Ready pods --all
echo "Port forwarding argocd to 443"
nohup kubectl port-forward -n argocd service/argocd-server 443:443 >/dev/null 2>&1 &
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -n "Argocd admin password: "
printf "\e[31m$PASS\e[0m\n"
echo "Creating projects"
kubectl apply -n argocd -f ../confs/project.yml
sleep 2
kubectl apply -n argocd -f ../confs/argocd-app.yml
sleep 2
kubectl wait -n argocd --for=condition=Ready pods --all
echo "Run the following command as root to port forwarding playground app to 8888"
echo "kubectl port-forward -n dev service/playground 8888:8888"
