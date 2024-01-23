
# ansible (ansible)

Ansible is an open source community project sponsored by Red Hat, it's the simplest way to automate IT.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/features/ansible:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| debug | Enable debug output. | boolean | false |
| version | Version to install. If not specified, the latest version will be installed. | string | - |
| venv_path | Path to the ansible home directory. | string | /opt/ansible |
| requirements | Required distribution packages. | string | curl,jq,libffi-dev,python3-venv |
| dependencies | Additional dependencies to install in the virtualenv. | string | - |

## Customizations

### VS Code Extensions

- `redhat.ansible`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/features/blob/main/src/ansible/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
