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

### Secrets

```
# ClickHouse
kubectl create secret generic clickhouse-password-default --from-literal=password='clickhouse' -n modrinth-infra
# Duplicate the secret in `modrinth` namespace, not using any external secrets manager so shrug
kubectl create secret generic clickhouse-password-default --from-literal=password='clickhouse' -n modrinth

# Postgres
kubectl create secret -n modrinth generic archon-psql-archon --type=kubernetes.io/basic-auth --from-literal=password='archon' --from-literal=username='archon'
kubectl create secret -n modrinth generic archon-psql-postgres --type=kubernetes.io/basic-auth --from-literal=password='postgres' --from-literal=username='postgres'
kubectl create secret -n modrinth generic labrinth-psql-labrinth --type=kubernetes.io/basic-auth --from-literal=password='labrinth' --from-literal=username='labrinth'
kubectl create secret -n modrinth generic labrinth-psql-postgres --type=kubernetes.io/basic-auth --from-literal=password='postgres' --from-literal=username='postgres'
```

### ClickHouse

```
clickhouse-clickhouse --password --port 9000 --host modrinth-clickhouse --user default
CREATE DATABASE archon ON CLUSTER 'default' ENGINE = Replicated;
CREATE DATABASE labrinth ON CLUSTER 'default' ENGINE = Replicated;
```

### Postgres (Archon)

```
kubectl exec -it -n modrinth cnpg-archon-1 -c postgres -- psql -U postgres -d postgres

GRANT CONNECT ON DATABASE archon TO archon;
GRANT USAGE ON SCHEMA public TO archon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO archon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO archon;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO archon;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO archon;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO archon;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON FUNCTIONS TO archon;
```

### Postgres (Labrinth)

```
kubectl exec -it -n modrinth cnpg-labrinth-1 -c postgres -- psql -U postgres -d postgres

GRANT CONNECT ON DATABASE labrinth TO labrinth;
GRANT USAGE ON SCHEMA public TO labrinth;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO labrinth;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO labrinth;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO labrinth;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO labrinth;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO labrinth;

ALTER DEFAULT PRIVILEGES FOR ROLE modrinth IN SCHEMA public
GRANT ALL PRIVILEGES ON FUNCTIONS TO labrinth;
```

You can use seed data by doing `psql-17 postgres://postgres@modrinth-psql-labrinth:5432/labrinth -f fixtures/labrinth-seed-data-202508052143.sql` and using the superuser password.
