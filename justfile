init:
  #!/usr/bin/env sh
  kubectl apply -f ./core/namespaces.yaml
  kubectl apply --server-side -k ./core/kustomize/crds

  sleep 1

  ./helm.sh

  kubectl apply -k ./core/kustomize/controller
  kubectl apply --server-side -k ./core/kustomize/cert-manager
  kubectl apply --server-side -k ./core/kustomize/redis
  kubectl apply --server-side -k ./core/kustomize/cnpg

  kubectl apply -k ./core --prune -l app.kubernetes.io/part-of=modrinth-stack

apply:
  #!/usr/bin/env sh
  kubectl apply -k ./core --prune -l app.kubernetes.io/part-of=modrinth-stack