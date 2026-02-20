### Configuring SeaweedFS

Setup a temporary pod to configure Seaweed:

```
kubectl run tmp --rm -it --image=debian:trixie --restart=Never -- sh
apt update && apt install wget
cd /root
wget https://github.com/seaweedfs/seaweedfs/releases/latest/download/linux_amd64.tar.gz
tar -xf linux_amd64.tar.gz
./weed shell -master seaweed-s3-master.modrinth-infra.svc.cluster.local:9333
```

In the weed shell:

```
fs.configure -locationPrefix=/buckets/ -volumeGrowthCount=1 -apply
```
