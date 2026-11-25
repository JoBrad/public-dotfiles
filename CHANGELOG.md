# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2026-11-25

### Added
- Documentation build system with automated docstring extraction
- `scripts/update-docs.sh` for auto-generating shell configuration documentation
- Shdoc-compatible docstrings to all 24 bash and zsh configuration files
- Auto-generated "Configuration files" sections in shell-specific READMEs
- Marker-based README injection (similar to terraform-docs)
- Comprehensive "Configuration Overview" in top-level README with links to shell-specific docs

### Changed
- Refactored top-level README for better organization
- Simplified devbox.json build command to use new build script
- Updated .gitignore to include scripts/ directory

### Documentation
- Added configuration file descriptions for all bash/.bashrc.d files
- Added configuration file descriptions for all zsh/.zshrc.d files
- Restructured README with clearer feature groupings

## [1.2.0] - 2026-05-21

### Added
- AWS profile manager: support for passing optional region when setting current profile

### Changed
- Reorganized Terraform/tofu configuration helpers
- Improved tfswitch config linking in zsh

### Documentation
- Added `tfpnc` alias documentation (plan output without color codes)

## [1.1.0] - 2026-03-15

### Added
- tfswitch config support for both Terraform and OpenTofu
- `tfpnc` alias for Terraform plan output without color codes (useful for file redirection)
- Azure Profile Manager helper (contributed by Austin Maddox)

### Changed
- Enhanced Azure CLI integration in zsh

### Fixed
- Git fetch and prune operations in multiple shells

## [1.0.0] - 2026-01-10

### Added
- Initial release of dotfiles configuration
- Bash customizations with comprehensive alias set
- Zsh customizations with GNU tools preference
- XDG Base Directory Specification compliance
- Privacy-focused shell defaults (no history persistence)
- Navigation shortcuts (.. ... ....)
- Directory listing aliases with GNU tools
- File safety defaults (backup-on-overwrite, rm guard)
- Archive management shortcuts (tarc, tarx)
- Enhanced diff defaults
- AWS CLI profile manager with completion support
- Git integration and helpers
- Docker Compose aliases
- OpenTofu and Terraform support
- PowerShell upgrade helpers
- direnv integration
- Node.js and npm XDG configuration (zsh)
- Grep colorization (bash)
- Process search utility (psgrep)
- Configuration reload utility (cls)
- Sudo privilege escalation shortcut (fuck)
- Two-line prompt configuration (bash)

[Unreleased]: https://github.com/JoBrad/public-dotfiles/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/JoBrad/public-dotfiles/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/JoBrad/public-dotfiles/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/JoBrad/public-dotfiles/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/JoBrad/public-dotfiles/releases/tag/v1.0.0
