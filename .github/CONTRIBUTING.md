# Contributing to KnightDragonX OS

Thank you for your interest in contributing! This document provides guidelines for contributing.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:
- Clear title and description
- Steps to reproduce the behavior
- Expected vs actual behavior
- System information (OS, GPU, Hyde version)
- Screenshots or logs if applicable

**Example:**
```markdown
**Bad:** "It doesn't work"

**Good:** "Hotspot service fails to start on Arch Linux with NVIDIA GPU. Error: 'Failed to enable unit, unit kdx-hotspot.service does not exist.'"
```

### Suggesting Features

Feature suggestions are welcome! Please provide:
- Clear description of the feature
- Use case and motivation
- Any alternative solutions considered

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push and open a PR

**PR Guidelines:**
- Keep changes focused and atomic
- Update documentation if needed
- Test on your system before submitting
- Be responsive to feedback

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/KnightDragonX-OS.git
cd KnightDragonX-OS

# Create a branch
git checkout -b feature/your-feature

# Make changes and test
# ...

# Commit and push
git commit -m "Add amazing feature"
git push origin feature/your-feature
```

## Code Style

### Shell Scripts
- Use `shellcheck` to lint scripts
- Follow best practices for error handling
- Add comments for complex logic
- Use descriptive variable names

### Configuration Files
- Maintain consistent formatting
- Add comments explaining non-obvious settings
- Follow upstream project conventions

### Documentation
- Use clear, concise language
- Include examples where helpful
- Keep README and wiki in sync
- Update changelog for significant changes

## Questions?

Feel free to open an issue for questions or join discussions in existing issues.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Accept constructive criticism
- Focus on what's best for the community
