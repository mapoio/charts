# PowerDNS Authoritative Server Helm Chart

这个Helm Chart用于在Kubernetes集群中部署PowerDNS Authoritative DNS服务器。

## 功能特性

- 支持多种数据库后端：MySQL、PostgreSQL和SQLite3
- 自动初始化数据库和表结构
- 通过环境变量配置PowerDNS
- 支持持久化存储（用于SQLite3）
- 支持通过API管理DNS记录
- 完整的Kubernetes集成，包括健康检查、资源限制等

## 先决条件

- Kubernetes 1.19+
- Helm 3.2.0+
- 已配置好的数据库（MySQL或PostgreSQL）或持久卷（用于SQLite3）

## 安装Chart

添加仓库：

```bash
helm repo add pdns-auth-repo https://your-repo-url/
helm repo update
```

安装Chart：

```bash
# 使用MySQL作为后端
helm install pdns-auth pdns-auth-repo/pdns-auth \
  --set database.type=mysql \
  --set database.mysql.host=mysql-host \
  --set database.mysql.password=your-password

# 使用PostgreSQL作为后端
helm install pdns-auth pdns-auth-repo/pdns-auth \
  --set database.type=pgsql \
  --set database.pgsql.host=pgsql-host \
  --set database.pgsql.password=your-password

# 使用SQLite3作为后端
helm install pdns-auth pdns-auth-repo/pdns-auth \
  --set database.type=sqlite3
```

## 卸载Chart

```bash
helm uninstall pdns-auth
```

## 配置

下表列出了PowerDNS Authoritative Server Helm Chart的可配置参数及其默认值。

| 参数                                  | 描述                                      | 默认值                   |
|---------------------------------------|-------------------------------------------|--------------------------|
| `image.repository`                    | PowerDNS镜像仓库                          | `powerdns/pdns-auth-49`  |
| `image.tag`                           | PowerDNS镜像标签                          | `latest`                 |
| `image.pullPolicy`                    | 镜像拉取策略                              | `IfNotPresent`           |
| `initJob.image.repository`            | 初始化Job镜像仓库                         | `bitnami/kubectl`        |
| `initJob.image.tag`                   | 初始化Job镜像标签                         | `latest`                 |
| `initJob.image.pullPolicy`            | 初始化Job镜像拉取策略                     | `IfNotPresent`           |
| `replicaCount`                        | 副本数量                                  | `1`                      |
| `database.type`                       | 数据库类型 (mysql, pgsql, sqlite3)        | `mysql`                  |
| `database.mysql.host`                 | MySQL主机                                 | `mysql`                  |
| `database.mysql.port`                 | MySQL端口                                 | `3306`                   |
| `database.mysql.user`                 | MySQL用户名                               | `powerdns`               |
| `database.mysql.password`             | MySQL密码                                 | `powerdns`               |
| `database.mysql.database`             | MySQL数据库名                             | `powerdns`               |
| `database.pgsql.host`                 | PostgreSQL主机                            | `postgresql`             |
| `database.pgsql.port`                 | PostgreSQL端口                            | `5432`                   |
| `database.pgsql.user`                 | PostgreSQL用户名                          | `powerdns`               |
| `database.pgsql.password`             | PostgreSQL密码                            | `powerdns`               |
| `database.pgsql.database`             | PostgreSQL数据库名                        | `powerdns`               |
| `database.sqlite3.database`           | SQLite3数据库文件路径                     | `/var/lib/powerdns/pdns.sqlite3` |
| `database.init.enabled`               | 是否启用数据库初始化                      | `true`                   |
| `database.init.skipCreate`            | 是否跳过数据库创建                        | `false`                  |
| `database.init.skipInit`              | 是否跳过表初始化                          | `false`                  |
| `config.api`                          | 是否启用API                               | `yes`                    |
| `config.api-key`                      | API密钥                                   | `changeme`               |
| `config.webserver`                    | 是否启用Web服务器                         | `yes`                    |
| `config.webserver-address`            | Web服务器监听地址                         | `0.0.0.0`                |
| `config.webserver-port`               | Web服务器端口                             | `8081`                   |
| `config.webserver-allow-from`         | 允许访问Web服务器的IP                     | `0.0.0.0/0,::/0`         |
| `config.local-address`                | DNS服务器监听地址                         | `0.0.0.0, ::`            |
| `config.local-port`                   | DNS服务器端口                             | `53`                     |
| `service.type`                        | 服务类型                                  | `ClusterIP`              |
| `service.port`                        | DNS服务端口                               | `53`                     |
| `service.apiPort`                     | API服务端口                               | `8081`                   |
| `persistence.enabled`                 | 是否启用持久化存储（用于SQLite3）         | `true`                   |
| `persistence.storageClass`            | 持久卷存储类                              | `""`                     |
| `persistence.accessMode`              | 持久卷访问模式                            | `ReadWriteOnce`          |
| `persistence.size`                    | 持久卷大小                                | `1Gi`                    |
| `resources`                           | CPU/内存资源请求/限制                     | 参见values.yaml          |
| `nodeSelector`                        | 节点选择器                                | `{}`                     |
| `tolerations`                         | 容忍度                                    | `[]`                     |
| `affinity`                            | 亲和性设置                                | `{}`                     |
| `podSecurityContext`                  | Pod安全上下文                             | `{}`                     |
| `securityContext`                     | 容器安全上下文                            | 参见values.yaml          |
| `serviceAccount.create`               | 是否创建服务账号                          | `true`                   |
| `serviceAccount.name`                 | 服务账号名称                              | `""`                     |
| `ingress.enabled`                     | 是否启用Ingress                           | `false`                  |
| `ingress.annotations`                 | Ingress注解                               | `{}`                     |
| `ingress.hosts`                       | Ingress主机配置                           | 参见values.yaml          |
| `ingress.tls`                         | Ingress TLS配置                           | `[]`                     |
| `networkPolicy.enabled`               | 是否启用网络策略                          | `false`                  |

## 使用示例

### 创建自定义values文件

创建一个名为`custom-values.yaml`的文件：

```yaml
image:
  tag: "4.9.0"

# 自定义初始化Job镜像
initJob:
  image:
    repository: bitnami/kubectl
    tag: "1.27"

database:
  type: mysql
  mysql:
    host: mysql.database.svc.cluster.local
    user: pdns
    password: mysecretpassword
    database: pdns

config:
  api-key: "yoursecretapikey"
  master: "yes"
  slave: "no"
  allow-axfr-ips: "10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"

resources:
  limits:
    cpu: 1
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

service:
  type: LoadBalancer

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: pdns-api.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: pdns-api-tls
      hosts:
        - pdns-api.example.com
```

### 安装Chart

```bash
helm install pdns-auth ./pdns-auth -f custom-values.yaml
```

## 初始化Job

本Chart使用一个单独的初始化Job来设置和配置数据库。默认情况下，它使用`bitnami/kubectl`镜像，该镜像包含了必要的数据库客户端工具（MySQL、PostgreSQL和SQLite3）。您可以通过`initJob.image`参数自定义此镜像。

初始化Job会执行以下操作：

1. 检查数据库连接
2. 如果需要，创建数据库
3. 如果数据库中没有表，则初始化表结构

您可以通过以下参数控制初始化行为：

- `database.init.enabled`: 是否启用初始化Job
- `database.init.skipCreate`: 是否跳过数据库创建
- `database.init.skipInit`: 是否跳过表初始化

## 安全建议

1. 始终更改默认的API密钥
2. 限制API和Web服务器的访问
3. 使用安全的数据库凭据
4. 考虑使用网络策略限制Pod的网络通信
5. 在生产环境中使用TLS保护API访问

## 故障排除

### 检查Pod状态

```bash
kubectl get pods -l app.kubernetes.io/name=pdns-auth
```

### 查看Pod日志

```bash
kubectl logs -l app.kubernetes.io/name=pdns-auth
```

### 检查数据库初始化作业

```bash
kubectl get jobs -l app.kubernetes.io/name=pdns-auth
kubectl logs job/pdns-auth-init
```

## 参考资料

- [PowerDNS官方文档](https://doc.powerdns.com/authoritative/)
- [PowerDNS Docker镜像](https://hub.docker.com/r/powerdns/pdns-auth-49)
- [PowerDNS GitHub仓库](https://github.com/PowerDNS/pdns) 