# YAKS Install Action

[![](https://github.com/citrusframework/yaks-install-action/workflows/Test/badge.svg?branch=main)](https://github.com/citrusframework/yaks-install-action/actions)

A GitHub Action for installing and using YAKS client tools.

## Usage

### Pre-requisites

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#example-workflow) is available below.
For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

For more information on inputs, see the [API Documentation](https://developer.github.com/v3/repos/releases/#input)

- `version`: The YAKS version to use (default: `latest`)
- `github_token`: Optional token used when fetching the latest YAKS release to avoid hitting rate limits (you should set it to `${{ secrets.GITHUB_TOKEN }}`)

### Example Workflow

Create a workflow (eg: `.github/workflows/create-cluster.yml`):

```yaml
name: YAKS

on: pull_request

jobs:
  yaks:
    runs-on: ubuntu-latest
    steps:
      - name: YAKS tools
        uses: citrusframework/yaks-install-action@v1.1
```

This uses [@citrusframework/yaks-install-action](https://www.github.com/citrusframework/yaks-install-action) GitHub Action to install the YAKS client binaries.

## Use specific version

By default, the action will resolve the latest released version of YAKS.
You can provide a specific version to install though.

Create a workflow (eg: `.github/workflows/create-cluster.yml`):

```yaml
name: YAKS

on: pull_request

jobs:
  yaks:
    runs-on: ubuntu-latest
    steps:
      - name: YAKS tools
        uses: citrusframework/yaks-install-action@v1.1
        with:
          version: v0.15.1 
```

This will try to resolve a YAKS release tag with `v0.15.1` and use this specific version.

## Use nightly releases

YAKS framework provides access to nightly snapshot pre-release versions.

Create a workflow (eg: `.github/workflows/create-cluster.yml`):

```yaml
name: YAKS

on: pull_request

jobs:
  yaks:
    runs-on: ubuntu-latest
    steps:
      - name: YAKS tools
        uses: citrusframework/yaks-install-action@v1.1
        with:
          version: nightly 
```

This will use the latest available nightly snapshot version of YAKS.
