helm repo add seaweedfs-operator https://seaweedfs.github.io/seaweedfs-operator/
helm install seaweedfs-operator seaweedfs-operator/seaweedfs-operator --create-namespace --namespace seaweedfs-operator