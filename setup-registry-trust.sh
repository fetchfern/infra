#!/bin/bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <user@host>"
  exit 1
fi

HOST="$1"
REGISTRY="registry.modrinth-infra.svc.cluster.local:5000"
REMOTE_CA_PATH="/etc/rancher/k3s/registry-ca.crt"
REMOTE_REGISTRIES="/etc/rancher/k3s/registries.yaml"

echo "extracting CA cert from cluster"
CA_CERT=$(kubectl get secret modrinth-infra-ca -n modrinth-infra -o jsonpath='{.data.ca\.crt}' | base64 -d)
K3S_SERVICE=$(ssh "$HOST" "if systemctl list-unit-files k3s.service | grep -q k3s.service; then echo k3s; else echo k3s-agent; fi")

ssh "$HOST" "sudo mkdir -p /etc/rancher/k3s"

echo "setting trust"
echo "$CA_CERT" | ssh "$HOST" "sudo tee $REMOTE_CA_PATH > /dev/null"

ssh "$HOST" "sudo tee $REMOTE_REGISTRIES > /dev/null" <<EOF
mirrors:
  $REGISTRY:
    endpoint:
      - "https://$REGISTRY"
configs:
  "$REGISTRY":
    tls:
      ca_file: $REMOTE_CA_PATH
EOF

ssh "$HOST" "sudo systemctl restart $K3S_SERVICE"

echo "done: $HOST"
