# Dotfiles

## Setup

Initialize the [neovim](https://github.com/cmvanb/nvimfiles),
[carbon-gtk](https://github.com/cmvanb/carbon-gtk) and
[carbon-qt](https://github.com/cmvanb/carbon-qt) submodules.

```bash
git submodule update --init --recursive
```

Deploy the host profile.

```bash
./deploy.sh install --host
```

## Documentation

- [docs/design.md](docs/design.md)
- [docs/profiles.md](docs/profiles.md)
- [docs/modules.md](docs/modules.md)
- [docs/theme.md](docs/theme.md)
- [docs/templates.md](docs/templates.md)
