#!/bin/bash

set -e

# Use Aliyun Heapster images
# Download yaml files# Download yaml files

wget -O grafana.yaml https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
wget -O heapster.yaml https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
wget -O influxdb.yaml https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

cp -p grafana.yaml grafana.yaml.bak$(date '+%Y%m%d%H%M%S')
# Set port ype as "NodePort" for test environment
sed -i "s/\# type: NodePort/type: NodePort/g" grafana.yaml
# Set only use API server proxy to access grafana

sed -i "s/value: \//\#value: \//g" grafana.yaml
sed -i "s/\# \#value: \/api/value: \/api/g" grafana.yaml
# Change heapster-grafana-amd64 version from v5.0.4 to v4.4.3, beacuse in gcr.io the latest version is v4.4.3
#sed -i "s/v5\.0\.4/v4\.4\.3/g" grafana.yaml
# Replace k8s.gcr.io image with registry.cn-shenzhen.aliyuncs.com/hyman0603
sed -i "s/k8s\.gcr\.io/registry\.cn-shenzhen\.aliyuncs\.com\/hyman0603/g" grafana.yaml

cp -p heapster.yaml heapster.yaml.bak$(date '+%Y%m%d%H%M%S')
# Replace k8s.gcr.io image with registry.cn-shenzhen.aliyuncs.com/hyman0603
sed -i "s/k8s\.gcr\.io/registry\.cn-shenzhen\.aliyuncs\.com\/hyman0603/g" heapster.yaml

cp -p influxdb.yaml influxdb.yaml.bak$(date '+%Y%m%d%H%M%S')
# Change heapster-influxdb-amd64 version from v1.5.2 to v1.3.3, beacuse in gcr.io the latest version is v1.3.3
#sed -i "s/v1\.5\.2/v1\.3\.3/g" influxdb.yaml
# Replace k8s.gcr.io image with registry.cn-shenzhen.aliyuncs.com/hyman0603
sed -i "s/k8s\.gcr\.io/registry\.cn-shenzhen\.aliyuncs\.com\/hyman0603/g" influxdb.yaml

wget -O heapster-rbac.yaml https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

# Create K8S resources
kubectl apply -f grafana.yaml
kubectl apply -f heapster.yaml
kubectl apply -f influxdb.yaml


kubectl apply -f heapster-rbac.yaml

# Check Pod status

kubectl get pods -n kube-system

# Check cluster info

kubectl cluster-info



