# Helm Charts Repository Usage Guide

This document provides detailed instructions on how to use this Helm charts repository.

## Table of Contents

- [Helm Charts Repository Usage Guide](#helm-charts-repository-usage-guide)
  - [Table of Contents](#table-of-contents)
  - [Adding the Repository](#adding-the-repository)
  - [Available Charts](#available-charts)
  - [Installing Charts](#installing-charts)
    - [Basic Installation](#basic-installation)
    - [Installation with Custom Values](#installation-with-custom-values)
    - [Installation with Values File](#installation-with-values-file)
  - [Customizing Chart Values](#customizing-chart-values)
  - [Upgrading Charts](#upgrading-charts)
  - [Uninstalling Charts](#uninstalling-charts)
  - [Contributing New Charts](#contributing-new-charts)
    - [Chart Structure](#chart-structure)
  - [Releasing Charts](#releasing-charts)

## Adding the Repository

To add this Helm repository to your Helm client:

```bash
helm repo add my-helm-charts https://mapoio.github.io/charts
helm repo update
```

## Available Charts

The following charts are available in this repository:

| Chart Name | Description | Chart Version | App Version |
|------------|-------------|---------------|------------|
| pdns-auth | PowerDNS Authoritative Server | 0.3.0 | 4.9.7 |
| pdns-admin | PowerDNS Admin Web Interface | 0.1.1 | 0.4.2 |
| vaultwarden | Vaultwarden (Bitwarden Compatible Password Manager) | 1.0.0 | 1.30.5 |

For detailed information about each chart, refer to its README.md file in the `charts/[CHART_NAME]` directory.

## Installing Charts

### Basic Installation

To install a chart with its default values:

```bash
helm install [RELEASE_NAME] my-helm-charts/[CHART_NAME]
```

For example:

```bash
helm install pdns-auth my-helm-charts/pdns-auth
helm install vaultwarden my-helm-charts/vaultwarden
```

### Installation with Custom Values

You can customize the installation by specifying values with `--set` flags:

```bash
# PowerDNS Auth example
helm install pdns-auth my-helm-charts/pdns-auth \
  --set database.type=mysql \
  --set database.mysql.host=my-mysql-server \
  --set database.mysql.password=my-secure-password

# Vaultwarden example  
helm install vaultwarden my-helm-charts/vaultwarden \
  --set vaultwarden.domain="https://vault.example.com" \
  --set vaultwarden.adminToken="$(echo -n 'your-admin-token' | base64)" \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host="vault.example.com"
```

### Installation with Values File

For more complex configurations, create a values file and use it during installation:

```bash
# PowerDNS Auth values file
cat > pdns-values.yaml << EOF
database:
  type: mysql
  mysql:
    host: my-mysql-server
    password: my-secure-password
config:
  api-key: my-api-key
  webserver-allow-from: 10.0.0.0/8
EOF

# Vaultwarden values file
cat > vaultwarden-values.yaml << EOF
vaultwarden:
  domain: "https://vault.example.com"
  adminToken: "$(echo -n 'your-admin-token' | base64)"
  security:
    signupsAllowed: false
ingress:
  enabled: true
  hosts:
    - host: vault.example.com
      paths:
        - path: /
          pathType: Prefix
persistence:
  enabled: true
  size: 10Gi
EOF

# Install with values files
helm install pdns-auth my-helm-charts/pdns-auth -f pdns-values.yaml
helm install vaultwarden my-helm-charts/vaultwarden -f vaultwarden-values.yaml
```

## Customizing Chart Values

Each chart has a set of configurable values. To see all available options for a chart:

```bash
helm show values my-helm-charts/[CHART_NAME]
```

For example:

```bash
helm show values my-helm-charts/pdns-auth
helm show values my-helm-charts/vaultwarden
```

## Upgrading Charts

To upgrade a release with new values:

```bash
helm upgrade pdns-auth my-helm-charts/pdns-auth \
  --set database.mysql.password=new-password
```

Or using a values file:

```bash
helm upgrade pdns-auth my-helm-charts/pdns-auth -f new-values.yaml
```

## Uninstalling Charts

To uninstall a chart release:

```bash
helm uninstall [RELEASE_NAME]
```

For example:

```bash
helm uninstall pdns-auth
```

## Contributing New Charts

To contribute a new chart to this repository:

1. Fork this repository
2. Create a new directory under `charts/` with your chart name
3. Develop your chart following the [Helm best practices](https://helm.sh/docs/chart_best_practices/)
4. Add documentation in a README.md file
5. Update the main README.md to include your chart
6. Submit a pull request

### Chart Structure

A typical chart structure should look like:

```
charts/
  my-chart/
    Chart.yaml
    values.yaml
    README.md
    templates/
      deployment.yaml
      service.yaml
      ...
```

## Releasing Charts

This repository uses GitHub Actions to automatically release charts when a new tag is pushed. The workflow does the following:

1. Packages the chart
2. Creates a GitHub release with the chart package
3. Updates the Helm repository index file

To release a new version of a chart:

1. Update the `version` field in the chart's `Chart.yaml` file
2. Commit and push your changes
3. Create and push a new tag with the format `v[CHART_VERSION]`

For example:

```bash
git tag -a v0.2.0 -m "Release v0.2.0"
git push origin v0.2.0
```

The GitHub Actions workflow will automatically build and release the chart. 