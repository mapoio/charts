# Contributing to Helm Charts Repository

Thank you for your interest in contributing to our Helm charts repository! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Contributing Process](#contributing-process)
- [Chart Requirements](#chart-requirements)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We expect all contributors to follow basic standards of conduct, including:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Add the upstream repository as a remote
4. Create a new branch for your changes

```bash
git clone https://github.com/YOUR_USERNAME/charts.git
cd charts
git remote add upstream https://github.com/mapoio/charts.git
git checkout -b feature/your-feature-name
```

## Development Environment

### Prerequisites

- Kubernetes cluster (minikube, kind, k3s, etc.)
- Helm 3.2.0+
- kubectl
- Git

### Setting Up

1. Install the required tools
2. Configure your Kubernetes cluster
3. Install the chart dependencies

## Contributing Process

### Adding a New Chart

1. Create a new directory under `charts/` with your chart name
2. Initialize the chart structure:

```bash
cd charts/
helm create your-chart-name
```

3. Modify the chart according to your requirements
4. Update the README.md with documentation for your chart
5. Add your chart to the list in the main README.md

### Modifying an Existing Chart

1. Make your changes to the chart
2. Update the chart version in `Chart.yaml` following [Semantic Versioning](https://semver.org/)
3. Update the chart's README.md if necessary

## Chart Requirements

All charts must:

1. Follow [Helm best practices](https://helm.sh/docs/chart_best_practices/)
2. Include a detailed README.md
3. Have appropriate NOTES.txt for post-installation instructions
4. Include relevant labels and annotations
5. Use appropriate Kubernetes resources
6. Handle security considerations appropriately
7. Include reasonable default values
8. Document all configurable values

## Testing

Before submitting a pull request, please test your chart:

1. Lint the chart:

```bash
helm lint charts/your-chart-name
```

2. Test the chart installation:

```bash
helm install test-release charts/your-chart-name --dry-run
helm install test-release charts/your-chart-name
```

3. Test chart functionality to ensure it works as expected

## Documentation

All charts should have:

1. A well-documented README.md file
2. Clear descriptions of all values in values.yaml
3. Usage examples
4. Notes on requirements and dependencies

## Pull Request Process

1. Ensure your code meets the requirements above
2. Update the documentation as necessary
3. Submit a pull request to the main repository
4. Address any feedback from reviewers

Thank you for contributing! 