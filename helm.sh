helm repo add seaweedfs-operator https://seaweedfs.github.io/seaweedfs-operator/
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
helm repo update

helm install seaweedfs-operator seaweedfs-operator/seaweedfs-operator --create-namespace --namespace seaweedfs-operator
helm install clickhouse-operator --create-namespace -n clickhouse-operator-system oci://ghcr.io/clickhouse/clickhouse-operator-helm
helm install redis-operator ot-helm/redis-operator --namespace ot-operators --set featureGates.GenerateConfigInInitContainer=true

echo "Use helm-install-tailscale-operator.sh <client-id> <client-secret> to install the tailscale operator. See https://tailscale.com/docs/features/kubernetes-operator"d