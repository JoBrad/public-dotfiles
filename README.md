# Dotfiles

This is my personal "dotfiles" configuration, which sets up my shortcuts and other shell customization options. It is designed to provide a similar experience between ZSH and Bash.

Tests were done on

- ZSH version 5.9
- Bash version 5.3.3(1)

Feel free to copy or contribute if you find them useful. Input is welcome!

# Installation

A rudimentary install script is in the root of this repo.

```sh
./install.sh zsh
```

# Development

Install [Devbox](https://www.jetify.com/devbox), then prepare the pinned shdoc
checkout and GNU awk:

```sh
devbox run build
```

The build script will clone the shdoc repository if needed, validate it's at the
correct revision, and auto-generate documentation for shell configuration files
by extracting their docstrings. Documentation is injected into shell-specific
READMEs between `<!-- BEGIN_SH_DOCS -->` and `<!-- END_SH_DOCS -->` markers.

# Configuration Overview

This project provides shell customizations organized by shell type, with shared
features across bash and zsh where applicable. Each shell has its own configuration
directory containing modular files that are sourced at startup.

## Common Features (Bash & Zsh)

- **XDG Base Directory Specification compliance** — All tools respect `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, and `XDG_STATE_HOME`.
- **Privacy-focused defaults** — Command history is not persisted to disk after session exit; terminal window titles are cleared on logout.
- **Navigation shortcuts** — `..`, `...`, and `....` for quick parent directory traversal.
- **Directory listing aliases** — `ll`, `la`, `l`, `lsd`, and `lw` with color output and sensible defaults.
- **File safety** — Backup-on-overwrite for `cp` and `mv`; `rm --preserve-root` guard.
- **Archive shortcuts** — `tarc` to create and `tarx` to extract compressed archives.
- **Enhanced diff** — Defaults to case-insensitive, whitespace-ignoring, side-by-side output.
- **Git integration** — Alias set for frequent git workflows; helpers for common patterns; optional directory shortcuts.
- **Cloud provider CLI tools** — AWS profile manager, Azure profile manager (zsh only), and OpenTofu/Terraform helpers.
- **Docker Compose aliases** — Short aliases for `up`, `down`, and `run` workflows.

## Shell-Specific Details

For detailed configuration and feature lists for each shell, see:

- [**Bash Configuration** (bash/README.md)](./bash/README.md) — Includes prompt customization, grep color output, and bash-specific features.
- [**Zsh Configuration** (zsh/README.md)](./zsh/README.md) — Includes Node.js/npm configuration, Azure CLI integration, and zsh-specific features.

# Notable changes

### 1.0

- Initial commit

### 1.1

- Added `tfswitch` config for both terraform and tofu
- Added `tfpnc` alias -> `tf plan -no-color -concise` (useful when redirecting a plan to a text file)
- Added Azure Profile Manager helper (by Austin Maddox)

### 1.2

- AWS profile manager: added support for an optional region to be passed when setting the current profile.
- Tf: Added `tfpnc` alias for plan output without color codes, useful when redirecting to a file.
