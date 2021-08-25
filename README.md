# YAKS Tools Action

[![](https://github.com/citrusframework/yaks-action/workflows/Test/badge.svg?branch=main)](https://github.com/citrusframework/yaks-action/actions)

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
      - name: YAKS client
        uses: citrusframework/yaks-action@v1
```

This uses [@citrusframework/yaks-action](https://www.github.com/citrusframework/yaks-action) GitHub Action to install the YAKS client binaries.
