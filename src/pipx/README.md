
# pipx (pipx)

Installs a pipx package.

## Example Usage

```json
"features": {
    "ghcr.io/nikaro/features/pipx:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the version of pipx to install. | string | latest |
| pipx_home | The directory to install pipx packages. | string | /opt/pipx |
| pipx_bin_dir | The directory to install pipx binaries. | string | /usr/local/bin |
| pipx_man_dir | The directory to install pipx manpages. | string | /usr/local/share/man |
| debug | Enable debug logging. | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/nikaro/features/blob/main/src/pipx/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
