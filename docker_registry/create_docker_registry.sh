#!/bin/bash


set -e

# Pull registry:2 image and run it
if [[ `docker ps | grep registry | wc -l` > 0 ]]; then
  docker stop registry
  docker rm registry
fi
docker run -d -p 5000:5000 -v /var/lib/docker-registry:/var/lib/registry -e REGISTRY_STORAGE_DELETE_ENABLED="true" --restart=always --name registry registry:2

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://5twf62k1.mirror.aliyuncs.com"],
  "insecure-registries": ["192.168.37.100:5000"]
}
EOF

# Restart docker
systemctl daemon-reload
systemctl restart docker