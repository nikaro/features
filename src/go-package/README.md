
# go-package (go-package)

Installs a go package.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/features/go-package:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| package | Select the go package to install. | string | - |
| version | Select the version of the go package to install. | string | latest |
| keep | Do not remove nanolayer. | boolean | false |
| debug | Enable debug logging. | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/features/blob/main/src/go-package/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
