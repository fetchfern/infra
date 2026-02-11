NGINX_GATEWAY_FABRIC_TAG="v2.3.0"
GATEWAY_API_TAG="v1.4.1"
CNPG_TAG="1.25.0"
REDIS_OPERATOR_TAG="v1.3.0"

kubectl config use-context orbstack

# Gateway api
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_TAG}/standard-install.yaml
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=${NGINX_GATEWAY_FABRIC_TAG}" | kubectl apply -f -
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGINX_GATEWAY_FABRIC_TAG}/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGINX_GATEWAY_FABRIC_TAG}/deploy/default/deploy.yaml

# CloudNativePG (PostgreSQL operator)
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.25/releases/cnpg-${CNPG_TAG}.yaml

# Redis operator (Spotahome)
kubectl apply -f https://raw.githubusercontent.com/spotahome/redis-operator/${REDIS_OPERATOR_TAG}/manifests/databases.spotahome.com_redisfailovers.yaml
kubectl apply -f https://raw.githubusercontent.com/spotahome/redis-operator/${REDIS_OPERATOR_TAG}/example/operator/all-redis-operator-resources.yaml

# Local overlay

kubectl apply -k k8s/overlays/local

# Check
kubectl get pods