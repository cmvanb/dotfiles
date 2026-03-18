# Modules

A module is a self-contained unit of configuration for one app or service. Each module lives at `modules/<name>/` and provides a `deploy.sh` that defines install/uninstall functions.

## Directory layout

```
modules/<name>/
├── src/           # config files, scripts, service files, templates
└── deploy.sh      # install/uninstall functions
```

`extras/<name>/` holds the same structure for reference/optional modules not included in any profile.

## Deploy script structure

Every `deploy.sh` provides `<name>::install()` and `<name>::uninstall()`. Some modules provide `<name>::enable()` / `<name>::disable()` for systemd user services.


```bash
<name>::install() {
    local src="$base_dir/modules/<name>/src"
    ensure_directory "$XDG_CONFIG_HOME/<app>"
    force_link "$src/config" "$XDG_CONFIG_HOME/<app>/config"
    render_esh_template "$src/style.esh.css" "$XDG_CONFIG_HOME/<app>/style.css"
}

<name>::uninstall() {
    rm -rf "$XDG_CONFIG_HOME/<app>"
}

<name>::enable()  { systemctl --user enable  <service>; }
<name>::disable() { systemctl --user disable <service>; }
```

`deploy.sh` uses `base_dir` (resolved to repo root) and the `XDG_*` vars exported by `deploy.sh`.

## Shared library functions

| Function | Effect |
|---|---|
| `force_link <src> <dest>` | `ln -sfT` — removes existing dir/file at dest first |
| `force_copy <src> <dest>` | `cp -rfT` — removes existing file/link at dest first |
| `ensure_directory <path>` | `mkdir -p` — removes existing file/link at path first |
| `happy_move <src> <dest>` | `mv` — no-ops if src == dest |
| `render_esh_template <tpl> <dest>` | Render ESH template to dest |

## Common deployment patterns

**Symlink entire directory**
```bash
force_link "$src" "$XDG_CONFIG_HOME/git"
```


**Symlink individual file**
```bash
force_link "$src/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"
```


**Render template file**
```bash
render_esh_template "$src/env.esh.sh" "$XDG_CONFIG_HOME/bash/env.sh"
```


**Variant file** (host/distro/wm specific)
```bash
force_link "$src/config~variant" "$XDG_CONFIG_HOME/app/config"
```


**Script alias**
```bash
force_link "$src/upload-to-0x0.sh" "$XDG_BIN_HOME/0x0"
```

## Example module

`modules/bat/deploy.sh`:
```bash
script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"

bat::install() {
    assert_dependency bat

    local src="$base_dir/modules/bat/src"

    ensure_directory "$XDG_CONFIG_HOME/bat"
    force_link "$src/config" "$XDG_CONFIG_HOME/bat/config"
    force_link "$src/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    render_esh_template "$base_dir/modules/theme-base/src/carbon-dark.syntect.esh.tmTheme" "$XDG_CONFIG_HOME/bat/themes/carbon-dark.syntect.tmTheme"

    bat cache --build
}

bat::uninstall() {
    rm -r "$XDG_CONFIG_HOME/bat"
}
```
