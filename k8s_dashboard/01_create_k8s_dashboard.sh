#!/bin/bash

set -e

# Use Aligyun k8s dashboard images
wget -O kubernetes-dashboard.yaml https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
cp -p kubernetes-dashboard.yaml kubernetes-dashboard.yaml.bak$(date '+%Y%m%d%H%M%S')

# Replace k8s.gcr.io image with registry.cn-shenzhen.aliyuncs.com/hyman0603
sed -i "s/k8s\.gcr\.io/registry\.cn-shenzhen\.aliyuncs\.com\/hyman0603/g" kubernetes-dashboard.yaml

# Deploy k8s master
kubectl apply -f kubernetes-dashboard.yaml

# Check pod status
kubectl get pods --namespace=kube-system  | grep kubernetes-dashboard

# Check pod details
kubectl describe pods kubernetes-dashboard --namespace=kube-system



