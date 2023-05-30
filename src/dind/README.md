
# docker-in-docker (dind)



## Example Usage

```json
"features": {
    "ghcr.io/nikaro/devcontainer-features/dind:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version to install. If not specified, the latest version will be installed. | string | - |
| buildx_version | Version to install. If not specified, the latest version will be installed. | string | - |
| username | Username to add to the docker group. | string | vscode |

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-docker`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/devcontainer-features/blob/main/src/dind/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
