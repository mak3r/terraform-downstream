#!/bin/sh

curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64" && sudo install -c -m 0755 vcluster /usr/local/bin && rm -f vcluster


# Memory and CPU limits
# We can pack about 100 vclusters into 8CPU 32GB RAM 
# with this configuration.
cat > ./vcluster.yaml << EOF
vcluster:
  resources:
    limits:
      memory: 290Mi
      cpu: 70m
    requests:
      cpu: 10m
      memory: 128Mi

EOF
