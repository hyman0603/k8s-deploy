#!/bin/bash

set -e

# Check version in https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# Search "Running kubeadm without an internet connection"
# For running kubeadm without an internet connection you have to pre-pull the required master images for the version of choice:
KUBE_VERSION=v1.11.0
KUBE_PAUSE_VERSION=3.1
CORE_DNS_VERSION=1.1.3

GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-shenzhen.aliyuncs.com/hyman0603

# When test v1.11.0, I found Kubernetes depends on both pause-amd64:3.1 and pause:3.1

images=(kube-proxy-amd64:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
coredns:${CORE_DNS_VERSION})

for imageName in ${images[@]} ; do
  docker pull $ALIYUN_URL/$imageName
  docker tag  $ALIYUN_URL/$imageName $GCR_URL/$imageName
  docker rmi $ALIYUN_URL/$imageName
done

docker pull registry.cn-shenzhen.aliyuncs.com/hyman0603/flannel:v0.10.0-amd64
docker tag registry.cn-shenzhen.aliyuncs.com/hyman0603/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64
docker rmi registry.cn-shenzhen.aliyuncs.com/hyman0603/flannel:v0.10.0-amd64

docker images

