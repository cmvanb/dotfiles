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

A module `deploy.sh` provides namespaced `install` and `uninstall` functions.

The install function typically uses `force_link` or `template::render_mako` to deploy individual config files, although where possible we also link entire directories.

```bash
<name>::install() {
    local src="$base_dir/modules/<name>/src"
    ensure_directory "$XDG_CONFIG_HOME/<app>"
    force_link "$src/config" "$XDG_CONFIG_HOME/<app>/config"
    template::render_mako "$src/style.mako.css" "$XDG_CONFIG_HOME/<app>/style.css"
}
```

The uninstall function simply removes installed files or links.

```bash
<name>::uninstall() {
    rm "$XDG_CONFIG_HOME/<app>/config"
    rm "$XDG_CONFIG_HOME/<app>/style.css"
}
```

Some modules provide `enable` / `disable` for systemd user services.

```bash
<name>::enable()  { systemctl --user enable  <service>; }
<name>::disable() { systemctl --user disable <service>; }
```

## Shared library functions

| Function | Effect |
|---|---|
| `force_link <src> <dest>` | `ln -sfT` — removes existing dir/file at dest first |
| `force_copy <src> <dest>` | `cp -rfT` — removes existing file/link at dest first |
| `ensure_directory <path>` | `mkdir -p` — removes existing file/link at path first |
| `happy_move <src> <dest>` | `mv` — no-ops if src == dest |
| `template::render_mako <tpl> <dest>` | Render Mako template to dest |

## Common deployment patterns

**Symlink entire directory**
```bash
force_link "$src" "$XDG_CONFIG_HOME/git"
```

Use this when all files in `src/` are static and the destination is owned entirely by this module.

**Symlink individual file**
```bash
force_link "$src/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"
```

Use individual file links when `src/` contains a mix of static files and templates, files from other modules, or host/distro variants.

**Render template file**
```bash
template::render_mako "$src/env.mako.sh" "$XDG_CONFIG_HOME/bash/env.sh"
```


**Variant file** (host/distro/wm specific)
```bash
force_link "$src/config.variant.ext" "$XDG_CONFIG_HOME/app/config.ext"
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
source "$base_dir/lib/template.sh"

bat::install() {
    assert_dependency bat

    local src="$base_dir/modules/bat/src"

    ensure_directory "$XDG_CONFIG_HOME/bat"
    force_link "$src/config" "$XDG_CONFIG_HOME/bat/config"
    force_link "$src/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    template::render_mako "$base_dir/modules/theme-base/src/carbon-dark.syntect.mako.tmTheme" "$XDG_CONFIG_HOME/bat/themes/carbon-dark.syntect.tmTheme"

    bat cache --build
}

bat::uninstall() {
    rm -r "$XDG_CONFIG_HOME/bat"
}
```
