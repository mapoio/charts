# PowerDNS Admin Helm Chart

This Helm Chart deploys PowerDNS Admin, a web interface for PowerDNS with advanced features.

## Introduction

PowerDNS Admin is a web-based PowerDNS management interface that provides a user-friendly way to manage PowerDNS servers. It offers various features including:

- Domain and record management
- User management and access control
- DNSSEC management
- API integration
- Multiple database support (MySQL, PostgreSQL, SQLite)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Deployed PowerDNS server (can be deployed using the pdns-auth chart)
- MySQL or PostgreSQL database (if not using SQLite)
- Persistent storage for SQLite database (only if using SQLite)

## Installing the Chart

To install the chart with the release name `pdns-admin`:

```bash
helm install pdns-admin ./charts/pdns-admin
```

This command deploys PowerDNS Admin on the Kubernetes cluster with default configuration.

## Uninstalling the Chart

To uninstall/delete the `pdns-admin` deployment:

```bash
helm uninstall pdns-admin
```

This command removes all Kubernetes components associated with the chart.

## Configuration

### Image Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `image.repository` | PowerDNS Admin image repository | `powerdnsadmin/pda-legacy` |
| `image.tag` | PowerDNS Admin image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### General Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `replicaCount` | Number of replicas | `1` |
| `resources` | Container resource requests and limits | See values.yaml |
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity settings | `{}` |

### Database Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `database.type` | Database type (mysql, postgres, sqlite) | `mysql` |
| `database.mysql.host` | MySQL host | `mysql` |
| `database.mysql.port` | MySQL port | `3306` |
| `database.mysql.user` | MySQL user | `pdnsadmin` |
| `database.mysql.password` | MySQL password | `pdnsadmin` |
| `database.mysql.database` | MySQL database name | `pdnsadmin` |
| `database.postgres.host` | PostgreSQL host | `postgresql` |
| `database.postgres.port` | PostgreSQL port | `5432` |
| `database.postgres.user` | PostgreSQL user | `pdnsadmin` |
| `database.postgres.password` | PostgreSQL password | `pdnsadmin` |
| `database.postgres.database` | PostgreSQL database name | `pdnsadmin` |
| `database.sqlite.database` | SQLite database file path | `/data/pdnsadmin.db` |

### PowerDNS API Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `pdns.proto` | PowerDNS API protocol | `http` |
| `pdns.host` | PowerDNS API host | `pdns-auth` |
| `pdns.port` | PowerDNS API port | `8081` |
| `pdns.api_key` | PowerDNS API key | `changeme` |
| `pdns.version` | PowerDNS version | `4.7.0` |

### Application Configuration Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `config.secret_key` | Flask secret key | `changeme` |
| `config.bind_address` | Bind address | `0.0.0.0` |
| `config.port` | Application port | `9191` |
| `config.login_title` | Login page title | `PowerDNS Admin` |
| `config.log_level` | Log level | `INFO` |
| `config.log_file` | Log file | `pdnsadmin.log` |
| `config.session_timeout` | Session timeout in minutes | `30` |
| `config.offline_mode` | Enable offline mode | `false` |
| `config.salt` | Salt for password hashing | `changeme` |

### Gunicorn Configuration Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `gunicorn.timeout` | Gunicorn timeout | `120` |
| `gunicorn.workers` | Number of Gunicorn workers | `4` |
| `gunicorn.loglevel` | Gunicorn log level | `info` |

### Authentication Parameters

#### Local Database Authentication

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.local_db_enabled` | Enable local database authentication | `true` |

#### LDAP Authentication

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.ldap.enabled` | Enable LDAP authentication | `false` |
| `auth.ldap.type` | LDAP type | `ldap` |
| `auth.ldap.uri` | LDAP URI | `ldap://ldap.example.com` |
| `auth.ldap.base_dn` | LDAP base DN | `dc=example,dc=com` |
| `auth.ldap.admin_username` | LDAP admin username | `""` |
| `auth.ldap.admin_password` | LDAP admin password | `""` |
| `auth.ldap.filter_basic` | LDAP basic filter | `""` |
| `auth.ldap.filter_username` | LDAP username filter | `""` |
| `auth.ldap.sg_enabled` | Enable LDAP security group | `false` |
| `auth.ldap.admin_group` | LDAP admin group | `""` |
| `auth.ldap.operator_group` | LDAP operator group | `""` |
| `auth.ldap.user_group` | LDAP user group | `""` |
| `auth.ldap.domain` | LDAP domain | `""` |

#### OAuth Authentication

##### Google OAuth

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.oauth.google.enabled` | Enable Google OAuth | `false` |
| `auth.oauth.google.client_id` | Google OAuth client ID | `""` |
| `auth.oauth.google.client_secret` | Google OAuth client secret | `""` |
| `auth.oauth.google.token_url` | Google OAuth token URL | `https://oauth2.googleapis.com/token` |
| `auth.oauth.google.scope` | Google OAuth scope | `openid email profile` |
| `auth.oauth.google.authorize_url` | Google OAuth authorize URL | `https://accounts.google.com/o/oauth2/auth` |
| `auth.oauth.google.base_url` | Google OAuth base URL | `https://www.googleapis.com/oauth2/v3/` |

##### GitHub OAuth

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.oauth.github.enabled` | Enable GitHub OAuth | `false` |
| `auth.oauth.github.key` | GitHub OAuth key | `""` |
| `auth.oauth.github.secret` | GitHub OAuth secret | `""` |
| `auth.oauth.github.scope` | GitHub OAuth scope | `email,profile` |
| `auth.oauth.github.api_url` | GitHub OAuth API URL | `https://api.github.com/` |
| `auth.oauth.github.token_url` | GitHub OAuth token URL | `https://github.com/login/oauth/access_token` |
| `auth.oauth.github.authorize_url` | GitHub OAuth authorize URL | `https://github.com/login/oauth/authorize` |

##### Azure OAuth

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.oauth.azure.enabled` | Enable Azure OAuth | `false` |
| `auth.oauth.azure.key` | Azure OAuth key | `""` |
| `auth.oauth.azure.secret` | Azure OAuth secret | `""` |
| `auth.oauth.azure.scope` | Azure OAuth scope | `email,profile` |
| `auth.oauth.azure.api_url` | Azure OAuth API URL | `""` |
| `auth.oauth.azure.token_url` | Azure OAuth token URL | `""` |
| `auth.oauth.azure.authorize_url` | Azure OAuth authorize URL | `""` |

##### OpenID Connect OAuth

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.oauth.oidc.enabled` | Enable OIDC OAuth | `false` |
| `auth.oauth.oidc.key` | OIDC OAuth key | `""` |
| `auth.oauth.oidc.secret` | OIDC OAuth secret | `""` |
| `auth.oauth.oidc.scope` | OIDC OAuth scope | `email,profile` |
| `auth.oauth.oidc.api_url` | OIDC OAuth API URL | `""` |
| `auth.oauth.oidc.token_url` | OIDC OAuth token URL | `""` |
| `auth.oauth.oidc.authorize_url` | OIDC OAuth authorize URL | `""` |

#### SAML Authentication

| Parameter | Description | Default |
| --- | --- | --- |
| `auth.saml.enabled` | Enable SAML authentication | `false` |
| `auth.saml.debug` | Enable SAML debug | `false` |
| `auth.saml.path` | SAML path | `""` |
| `auth.saml.metadata_url` | SAML metadata URL | `""` |
| `auth.saml.metadata_cache_lifetime` | SAML metadata cache lifetime | `1` |
| `auth.saml.idp_sso_binding` | SAML IDP SSO binding | `""` |
| `auth.saml.idp_entity_id` | SAML IDP entity ID | `""` |
| `auth.saml.nameid_format` | SAML name ID format | `""` |
| `auth.saml.attribute_email` | SAML email attribute | `""` |
| `auth.saml.attribute_givenname` | SAML given name attribute | `""` |
| `auth.saml.attribute_surname` | SAML surname attribute | `""` |
| `auth.saml.attribute_name` | SAML name attribute | `""` |
| `auth.saml.attribute_username` | SAML username attribute | `""` |
| `auth.saml.attribute_admin` | SAML admin attribute | `""` |
| `auth.saml.attribute_group` | SAML group attribute | `""` |
| `auth.saml.group_admin_name` | SAML admin group name | `""` |
| `auth.saml.group_to_account_mapping` | SAML group to account mapping | `""` |
| `auth.saml.attribute_account` | SAML account attribute | `""` |
| `auth.saml.sp_entity_id` | SAML SP entity ID | `""` |
| `auth.saml.sp_contact_name` | SAML SP contact name | `""` |
| `auth.saml.sp_contact_mail` | SAML SP contact email | `""` |
| `auth.saml.sign_request` | SAML sign request | `false` |
| `auth.saml.want_message_signed` | SAML want message signed | `false` |
| `auth.saml.logout` | SAML logout | `false` |
| `auth.saml.logout_url` | SAML logout URL | `""` |

### Default Admin User Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `admin.enabled` | Enable default admin user creation | `false` |
| `admin.username` | Admin username | `admin` |
| `admin.password` | Admin password | `changeme` |
| `admin.firstname` | Admin first name | `PowerDNS` |
| `admin.lastname` | Admin last name | `Admin` |
| `admin.email` | Admin email | `admin@example.com` |

### Service Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `service.annotations` | Service annotations | `{}` |
| `service.loadBalancerIP` | LoadBalancer IP | `""` |
| `service.externalTrafficPolicy` | External traffic policy | `""` |

### Persistence Parameters (Only for SQLite)

| Parameter | Description | Default |
| --- | --- | --- |
| `persistence.storageClass` | Storage class | `""` |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `1Gi` |

**Note:** Persistence is automatically enabled when using SQLite as the database type. The `persistence.enabled` parameter is ignored in this case.

### Health Check Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `livenessProbe.enabled` | Enable liveness probe | `true` |
| `livenessProbe.initialDelaySeconds` | Initial delay seconds | `300` |
| `livenessProbe.periodSeconds` | Period seconds | `30` |
| `livenessProbe.timeoutSeconds` | Timeout seconds | `5` |
| `livenessProbe.failureThreshold` | Failure threshold | `10` |
| `livenessProbe.successThreshold` | Success threshold | `1` |
| `readinessProbe.enabled` | Enable readiness probe | `true` |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds | `300` |
| `readinessProbe.periodSeconds` | Period seconds | `10` |
| `readinessProbe.timeoutSeconds` | Timeout seconds | `5` |
| `readinessProbe.failureThreshold` | Failure threshold | `3` |
| `readinessProbe.successThreshold` | Success threshold | `1` |

### Ingress Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts | `[{host: "pdns-admin.example.com", paths: [{path: "/", pathType: "Prefix"}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

## Integration with PowerDNS

To integrate PowerDNS Admin with PowerDNS:

1. Deploy PowerDNS using the pdns-auth chart
2. Configure PowerDNS Admin to connect to PowerDNS API by setting the following values:
   ```yaml
   pdns:
     proto: http
     host: pdns-auth
     port: 8081
     api_key: your_api_key
     version: 4.7.0
   ```

## Database Support

PowerDNS Admin supports three database types:

1. **MySQL** - Default option, requires an external MySQL database
2. **PostgreSQL** - Requires an external PostgreSQL database
3. **SQLite** - Embedded database, requires persistent storage

When using SQLite, a PersistentVolumeClaim is automatically created to store the database file at `/data/pdnsadmin.db`. No external database is required in this case.

To use SQLite, set the following in your values file:

```yaml
database:
  type: sqlite
  sqlite:
    database: /data/pdnsadmin.db
```

## Security

It is highly recommended to:

1. Generate a strong secret key for `config.secret_key`
2. Generate a strong salt for `config.salt`
3. Use a secure password for the PowerDNS API key
4. Use secure passwords for database connections
5. Configure TLS for ingress 