# PowerDNS Authoritative Server Helm Chart

This Helm chart deploys PowerDNS Authoritative Server on a Kubernetes cluster.

## Features

- Supports multiple database backends: MySQL, PostgreSQL, SQLite3
- Automatic database initialization through init jobs
- Dynamic configuration generation with variable substitution
- Rolling update deployment strategy
- Health checks with API authentication
- Configurable through values.yaml with environment variable mapping
- Includes all necessary Kubernetes resources (Services, ServiceAccounts, ConfigMaps, etc.)
- Security-focused configuration

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if using SQLite3 with persistence)
- Database (MySQL or PostgreSQL) if not using SQLite3

## Installing the Chart

```bash
# Basic installation
helm install pdns-auth ./charts/pdns-auth --namespace pdns --create-namespace

# With custom values
helm install pdns-auth ./charts/pdns-auth \
  --namespace pdns \
  --create-namespace \
  --set database.type=mysql \
  --set database.mysql.host=my-mysql-server \
  --set config.api-key=my-secret-key
```

## Usage Examples

### MySQL Database Setup

```yaml
# values-mysql.yaml
database:
  type: mysql
  mysql:
    host: mysql-server
    port: 3306
    user: powerdns
    password: mypassword
    database: powerdns

config:
  launch: "gmysql"
  api: "yes"
  api-key: "your-secret-api-key"
  webserver: "yes"
  webserver-address: "0.0.0.0"
  webserver-port: "8081"
```

### PostgreSQL Database Setup

```yaml
# values-postgres.yaml
database:
  type: pgsql
  pgsql:
    host: postgres-server
    port: 5432
    user: powerdns
    password: mypassword
    database: powerdns

config:
  launch: "gpgsql"
  api: "yes"
  api-key: "your-secret-api-key"
  webserver: "yes"
  webserver-address: "0.0.0.0"
  webserver-port: "8081"
```

## Configuration

The following table lists the configurable parameters of the PowerDNS Auth chart and their default values.

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | PowerDNS Auth image repository | `powerdns/pdns-auth-49` |
| `image.tag` | PowerDNS Auth image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Database Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `database.type` | Database type (mysql, pgsql, sqlite3) | `mysql` |
| `database.mysql.host` | MySQL host | `mysql` |
| `database.mysql.port` | MySQL port | `3306` |
| `database.mysql.user` | MySQL user | `powerdns` |
| `database.mysql.password` | MySQL password | `powerdns` |
| `database.mysql.database` | MySQL database name | `powerdns` |
| `database.pgsql.host` | PostgreSQL host | `postgresql` |
| `database.pgsql.port` | PostgreSQL port | `5432` |
| `database.pgsql.user` | PostgreSQL user | `powerdns` |
| `database.pgsql.password` | PostgreSQL password | `powerdns` |
| `database.pgsql.database` | PostgreSQL database name | `powerdns` |
| `database.sqlite3.database` | SQLite3 database path | `/var/lib/powerdns/pdns.sqlite3` |
| `database.init.enabled` | Enable database initialization | `true` |
| `database.init.skipCreate` | Skip database creation | `false` |
| `database.init.skipInit` | Skip schema initialization | `false` |

### PowerDNS Configuration

All PowerDNS configuration parameters are defined in the `config` section. These will be converted to environment variables with the `PDNS_` prefix. For example, `allow-axfr-ips` will be converted to `PDNS_ALLOW_AXFR_IPS`.

Refer to the [PowerDNS settings documentation](https://doc.powerdns.com/authoritative/settings.html) for all available options.

### Persistence Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence (for SQLite3) | `true` |
| `persistence.storageClass` | Storage class for PVC | `""` |
| `persistence.accessMode` | Access mode for PVC | `ReadWriteOnce` |
| `persistence.size` | Size of PVC | `1Gi` |

### Deployment Strategy

| Parameter | Description | Default |
|-----------|-------------|---------|
| `strategy.rollingUpdate.maxSurge` | Maximum number of pods that can be created above desired replicas | `25%` |
| `strategy.rollingUpdate.maxUnavailable` | Maximum number of pods that can be unavailable during update | `25%` |

### Health Check Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.enabled` | Enable liveness probe | `true` |
| `livenessProbe.initialDelaySeconds` | Initial delay before first probe | `30` |
| `livenessProbe.periodSeconds` | How often to perform the probe | `10` |
| `livenessProbe.timeoutSeconds` | When the probe times out | `5` |
| `livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed | `3` |
| `readinessProbe.enabled` | Enable readiness probe | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay before first probe | `5` |
| `readinessProbe.periodSeconds` | How often to perform the probe | `10` |
| `readinessProbe.timeoutSeconds` | When the probe times out | `5` |
| `readinessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed | `3` |

### Network Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | DNS service port | `53` |
| `service.apiPort` | API service port | `8081` |
| `ingress.enabled` | Enable ingress for API | `false` |
| `networkPolicy.enabled` | Enable network policy | `false` |

## Reference Documentation

- [PowerDNS Auth Docker Image](https://hub.docker.com/r/powerdns/pdns-auth-49)
- [PostgreSQL Schema](https://github.com/PowerDNS/pdns/blob/master/modules/gpgsqlbackend/schema.pgsql.sql)
- [MySQL Schema](https://github.com/PowerDNS/pdns/blob/master/modules/gmysqlbackend/schema.mysql.sql)
- [SQLite3 Schema](https://github.com/PowerDNS/pdns/blob/master/modules/gsqlite3backend/schema.sqlite3.sql)
- [PowerDNS Docker Documentation](https://github.com/PowerDNS/pdns/blob/master/Docker-README.md)
- [PowerDNS Settings](https://doc.powerdns.com/authoritative/settings.html) 