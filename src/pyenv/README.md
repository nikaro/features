
# pyenv (pyenv)

Simple Python version management.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/devcontainer-features/pyenv:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| pyenv_git_tag | Version to install. If not specified, the latest version will be installed. | string | - |
| pyenv_root | Path to the poetry home directory. | string | /opt/pyenv |
| python_version | Python version to install through pyenv. If not specified, the latest version will be installed. | string | - |

## Customizations

### VS Code Extensions

- `ms-python.python`
- `ms-python.vscode-pylance`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/devcontainer-features/blob/main/src/pyenv/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
