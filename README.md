# Helm Charts Repository

This repository contains a collection of Helm charts for various applications. Each chart is designed to be easily deployable on Kubernetes clusters.

## Available Charts

- [PowerDNS Authoritative Server](./charts/pdns-auth/README.md) - A Helm chart for PowerDNS Authoritative Server

## Usage

For detailed usage instructions, please see the [Usage Guide](./USAGE.md).

### Quick Start

#### Adding the Helm Repository

```bash
helm repo add my-helm-charts https://mapoio.github.io/charts
helm repo update
```

#### Installing a Chart

```bash
helm install [RELEASE_NAME] my-helm-charts/[CHART_NAME]
```

For example:

```bash
helm install pdns-auth my-helm-charts/pdns-auth
```

## Development

### Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

### Adding a New Chart

1. Create a new directory under `charts/` with your chart name
2. Develop your chart following the Helm best practices
3. Update the documentation in the chart's README.md
4. Add the chart to the list in the main README.md

## Contributing

Contributions are welcome! Please read our [Contributing Guide](./CONTRIBUTING.md) for details on how to submit pull requests, the development process, and coding standards.

## License

This project is licensed under the MIT License - see the LICENSE file for details.