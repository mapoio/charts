# Vaultwarden Helm Chart

## 概述

这是一个生产级别的 Vaultwarden Helm Chart，用于在 Kubernetes 集群中部署 Vaultwarden（Bitwarden 兼容的密码管理器服务）。

## 特性

- 🔒 **生产级安全配置**：非 root 用户运行、只读根文件系统、严格的安全上下文
- 🗄️ **多数据库支持**：SQLite、MySQL、PostgreSQL
- 📧 **SMTP 集成**：邮件通知和验证支持
- 🌐 **Ingress 支持**：包含 WebSocket 路由配置
- 📊 **监控就绪**：健康检查、ServiceMonitor 支持
- 🔄 **高可用性**：Pod 反亲和性、PDB、HPA 支持
- 🛡️ **网络策略**：精细化网络访问控制
- 💾 **持久化存储**：数据持久化和备份配置

## 先决条件

- Kubernetes 1.19+
- Helm 3.2.0+
- 持久卷提供程序（如需数据持久化）
- Ingress 控制器（如需外部访问）

## 安装

### 添加 Helm 仓库

```bash
helm repo add my-charts https://mapoio.github.io/charts
helm repo update
```

### 快速开始

```bash
# 使用默认配置安装
helm install my-vaultwarden my-charts/vaultwarden

# 使用自定义配置文件安装
helm install my-vaultwarden my-charts/vaultwarden -f values.yaml
```

### 生产环境部署示例

```bash
helm install vaultwarden my-charts/vaultwarden \
  --set vaultwarden.domain="https://vault.example.com" \
  --set vaultwarden.adminToken="$(echo -n 'your-admin-token' | base64)" \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host="vault.example.com" \
  --set persistence.enabled=true \
  --set persistence.size="10Gi"
```

## 配置

### 核心配置

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `vaultwarden.domain` | 应用域名（必需） | `"https://vault.example.com"` |
| `vaultwarden.adminToken` | 管理员令牌（base64编码） | `""` |
| `vaultwarden.security.signupsAllowed` | 允许新用户注册 | `false` |
| `vaultwarden.security.invitationsAllowed` | 允许组织邀请 | `true` |

### 数据库配置

#### SQLite（默认）
```yaml
vaultwarden:
  database:
    type: sqlite
    url: "data/db.sqlite3"
```

#### MySQL
```yaml
vaultwarden:
  database:
    type: mysql
externalDatabase:
  mysql:
    enabled: true
    host: "mysql-server"
    database: "vaultwarden"
    username: "vaultwarden"
    password: "your-password"
```

#### PostgreSQL
```yaml
vaultwarden:
  database:
    type: postgres
externalDatabase:
  postgres:
    enabled: true
    host: "postgres-server"
    database: "vaultwarden"
    username: "vaultwarden"
    password: "your-password"
```

### SMTP 配置

```yaml
vaultwarden:
  smtp:
    enabled: true
    host: "smtp.example.com"
    port: 587
    security: "starttls"
    username: "noreply@example.com"
    password: "your-smtp-password"
    from: "vaultwarden@example.com"
```

### Ingress 配置

```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  hosts:
    - host: vault.example.com
      paths:
        - path: /
          pathType: Prefix
        - path: /notifications/hub
          pathType: Prefix
          service:
            name: vaultwarden-ws
            port: 3012
  tls:
    - secretName: vaultwarden-tls
      hosts:
        - vault.example.com
```

### 安全配置

```yaml
securityContext:
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  runAsUser: 65534
  capabilities:
    drop:
      - ALL
  readOnlyRootFilesystem: true

networkPolicy:
  enabled: true
  policyTypes:
    - Ingress
    - Egress
```

### 持久化存储

```yaml
persistence:
  enabled: true
  storageClass: "fast-ssd"
  size: "10Gi"
  accessMode: ReadWriteOnce
```

## 管理任务

### 生成管理员令牌

```bash
# 生成 base64 编码的管理员令牌
echo -n "your-secret-admin-token" | base64
```

### 访问管理界面

管理界面位于：`https://your-domain/admin`

### 备份数据

对于 SQLite：
```bash
kubectl exec deployment/vaultwarden -- sqlite3 /data/db.sqlite3 ".backup /data/backup.db"
```

### 升级

```bash
helm upgrade vaultwarden my-charts/vaultwarden -f values.yaml
```

## 故障排除

### 常见问题

1. **Pod 无法启动**
   - 检查存储类是否可用
   - 验证安全上下文配置
   - 查看 pod 日志：`kubectl logs deployment/vaultwarden`

2. **无法访问 Web 界面**
   - 确认 Ingress 配置正确
   - 检查防火墙和 DNS 设置
   - 验证 TLS 证书

3. **数据库连接问题**
   - 检查数据库凭据和连接字符串
   - 确认网络策略允许数据库访问
   - 验证数据库服务可达性

### 日志查看

```bash
# 查看应用日志
kubectl logs -f deployment/vaultwarden

# 查看事件
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 安全建议

1. **启用网络策略**以限制网络访问
2. **使用强管理员令牌**并定期轮换
3. **启用 TLS**并使用有效证书
4. **定期备份数据**
5. **监控应用日志**异常活动
6. **限制用户注册**（生产环境）
7. **配置资源限制**防止资源耗尽

## 监控

### Prometheus 集成

```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 30s
```

### 健康检查

Chart 包含配置好的存活性和就绪性探针：

```yaml
livenessProbe:
  enabled: true
  httpGet:
    path: /alive
    port: http
readinessProbe:
  enabled: true
  httpGet:
    path: /alive
    port: http
```

## 贡献

欢迎提交问题和功能请求到项目仓库。

## 许可证

此项目使用 MIT 许可证 - 详见 LICENSE 文件。