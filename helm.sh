helm repo add seaweedfs-operator https://seaweedfs.github.io/seaweedfs-operator/
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm install seaweedfs-operator seaweedfs-operator/seaweedfs-operator --create-namespace --namespace seaweedfs-operator
helm install clickhouse-operator --create-namespace -n clickhouse-operator-system oci://ghcr.io/clickhouse/clickhouse-operator-helm

echo "Use helm-install-tailscale-operator.sh <client-id> <client-secret> to install the tailscale operator. See https://tailscale.com/docs/features/kubernetes-operator"