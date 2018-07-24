#!/bin/bash

set -e

# install helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# tab helm
helm completion bash > .helmrc;echo "source .helmrc" >> .bashrc

# echo version
helm version

# instal tiller
