# Contributing

Thank you for your interest in contributing to CMS Cultivator! This document provides guidelines for contributing to the project.

---

## Getting Started

### Prerequisites

- Git
- Python 3.x (for Zensical documentation)
- Claude Code CLI (for testing commands)
- Basic knowledge of Markdown

### Setting Up Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/cms-cultivator.git
   cd cms-cultivator
   ```

3. **Install Zensical** (for documentation):
   ```bash
   pip install zensical
   ```

4. **Test the plugin locally**:
   ```bash
   # Link to Claude Code plugins directory
   ln -s $(pwd) ~/.config/claude/plugins/cms-cultivator
   claude plugins enable cms-cultivator
   ```

---

## Making Changes

### Adding a New Command

#### 1. Create command file in `/commands/`

```bash
touch commands/my-new-command.md
```

#### 2. Add frontmatter at the top

```yaml
---
description: Brief description of what the command does
argument-hint: [optional-arg]
allowed-tools: Bash(git:*), Read, Glob, Grep, Write
---
```

#### 3. Write command documentation

- Clear usage instructions
- Example outputs
- Drupal/WordPress-specific considerations
- Integration with Kanopi tools (if applicable)

#### 4. Test the command

```bash
# In Claude Code
/my-new-command
```

#### 5. Add to documentation

- Update `docs/commands/overview.md`
- Add detailed guide if needed

### Updating Existing Commands

#### 1. Modify command file in `/commands/`

#### 2. Test thoroughly

- Try different arguments
- Test with both Drupal and WordPress projects
- Verify Kanopi tool integration

#### 3. Update documentation if behavior changed

### Improving Documentation

#### 1. Edit files in `/docs/`

#### 2. Preview locally

```bash
zensical serve
# Visit http://localhost:8000
```

#### 3. Build to verify

```bash
zensical build --clean
```

---

## Coding Standards

### Command Files (`.md`)

- Use clear, descriptive headings
- Include code examples with proper syntax highlighting
- Provide both Drupal and WordPress examples where applicable
- Document all arguments and focus options
- Include expected output examples

### Documentation

- Write in clear, concise language
- Use proper Markdown formatting
- Include code examples with syntax highlighting
- Add admonitions for warnings/tips:
  ```markdown
  !!! warning
      Important warning text

  !!! tip
      Helpful tip text
  ```

### Frontmatter

- `description`: Brief one-line description
- `argument-hint`: Show optional arguments in square brackets
- `allowed-tools`: List all tools the command can use

---

## Pull Request Process

### 1. Create a branch from `main`

```bash
git checkout -b feature/my-new-feature
```

### 2. Make your changes

- Follow coding standards
- Add/update documentation
- Test thoroughly

### 3. Commit your changes

```bash
git add .
git commit -m "feat: add new command for X"
```

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance

### 4. Push to your fork

```bash
git push origin feature/my-new-feature
```

### 5. Create Pull Request on GitHub

- Provide clear description
- Reference any issues
- Add screenshots if relevant

### 6. Address review feedback

- Make requested changes
- Push updates to same branch

---

## Testing Guidelines

### Manual Testing

#### 1. Install plugin locally

```bash
claude plugins enable cms-cultivator
```

#### 2. Test command variations

- Without arguments
- With different focus options
- In Drupal project
- In WordPress project

#### 3. Verify Kanopi integration

- Test with `ddev composer` commands
- Verify `ddev` custom commands work

### Documentation Testing

```bash
# Build docs locally
zensical build --clean

# Serve docs locally
zensical serve
```

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior

- Be respectful and considerate
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks
- Publishing others' private information
- Other unethical or unprofessional conduct

---

## Getting Help

- **GitHub Issues**: [Report bugs or request features](https://github.com/kanopi/cms-cultivator/issues)
- **GitHub Discussions**: [Ask questions or share ideas](https://github.com/kanopi/cms-cultivator/discussions)
- **Documentation**: [Read the full docs](https://kanopi.github.io/cms-cultivator/)

---

## Recognition

Contributors will be recognized in:
- `CHANGELOG.md` for significant contributions
- GitHub contributors page
- Project documentation (where applicable)

---

## License

By contributing to CMS Cultivator, you agree that your contributions will be licensed under the GPL-2.0-or-later license.

---

Thank you for contributing to CMS Cultivator! 🎉
