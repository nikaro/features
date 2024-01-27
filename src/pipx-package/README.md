
# pipx-package (pipx-package)

Installs a pipx package.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/features/pipx-package:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| package | Select the pipx package to install. | string | - |
| version | Select the version of the pipx package to install. | string | latest |
| injections | Space delimitered list of python packages to inject into the main package env | string | - |
| includeDeps | Include apps of dependent packages | boolean | false |
| debug | Enable debug logging. | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/features/blob/main/src/pipx-package/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
