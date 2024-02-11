
# ansible-lint (ansible-lint)

Linter for Ansible.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/features/ansible-lint:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| debug | Enable debug output. | boolean | false |
| ansible_lint_version | Version to install. If not specified, the latest version will be installed. | string | - |
| ansible_lint_home | Path to the ansible-lint home directory. | string | /opt/ansible-lint |

## Customizations

### VS Code Extensions

- `redhat.ansible`
- `redhat.vscode-yaml`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/features/blob/main/src/ansible-lint/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
