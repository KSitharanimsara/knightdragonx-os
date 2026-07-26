# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions CI workflow for script linting and markdown validation
- Issue templates for bug reports and feature requests
- CONTRIBUTING.md with contribution guidelines
- Backup functionality to installer and post-install scripts
- Colored output and logging functions to installation scripts
- Restore point creation during installation
- Error handling and user confirmation for NVIDIA driver installation
- Warnings when optional components are missing

### Changed
- Improved error handling in installer.sh with proper exit codes
- Enhanced post-install.sh with backup of existing configs
- Better user feedback with colored status messages
- GPU driver installation now requires user confirmation for NVIDIA
- Script step numbering updated (installer: 6 steps, post-install: 7 steps)

### Fixed
- Removed reference to non-existent hotspot service in post-install output
- Added warnings instead of silent failures for missing config directories
- Improved path handling in copy operations

### Deprecated
- Hotspot service references (service no longer exists)

## [1.0.0] - Initial Release

### Added
- KnightDragonX theme for HyDE
- Hyprland configuration
- Waybar, Rofi, Kitty, and Kvantum configurations
- Automated installer script
- Post-installation configuration script
- SDDM theme integration
- Documentation and wiki articles
