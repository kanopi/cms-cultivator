# CMS Cultivator

Specialist agents and auto-invoked skills for Drupal/WordPress development. Works in Claude Code, Claude Desktop, and OpenAI Codex.

**Full documentation:** [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

> **What changed in 2.0?** CMS Cultivator now focuses on CMS development
> workflows. Delivery Record moved to its own public library:
> [kanopi/delivery-record](https://github.com/kanopi/delivery-record). Audit,
> DevOps, and PM capabilities moved to separate internal Kanopi libraries.
> The final 1.x release remains available as a tagged reference.

---

## Quick Start

**Claude Code — Via Marketplace (Recommended)**

```bash
# Add the Claude Toolbox marketplace
/plugin marketplace add kanopi/claude-toolbox

# Install CMS Cultivator
/plugin install cms-cultivator@claude-toolbox
```

**Claude Code — Local development**

```bash
git clone https://github.com/kanopi/cms-cultivator
claude --plugin-dir /path/to/cms-cultivator
```

**OpenAI Codex — Via Marketplace**

```bash
# Add the Kanopi marketplace
codex plugin marketplace add kanopi/claude-toolbox

# Open the plugin browser and install CMS Cultivator
codex/plugins
```

See [Installation Guide](https://kanopi.github.io/cms-cultivator/installation/) for complete setup instructions.

---

## Key Features

### PR Workflows
Generate commit messages, PR descriptions, changelogs, and review code.

**Skills:**
- `commit-message-generator` - Generate conventional commit messages
- `pr-create` - Create PR with generated description
- `pr-review` - AI-assisted code review
- `pr-release` - Generate release PR with changelog

### Testing & Code Quality
Standards compliance, test generation, and coverage analysis.

**Skills:**
- `code-standards-checker` - Coding standards compliance (PHPCS, ESLint)
- `test-scaffolding` - Generate test scaffolding
- `coverage-analyzer` - Analyze test coverage gaps
- `test-plan-generator` - Create comprehensive QA test plans

### Design-to-Code
Figma → WordPress blocks, Drupal paragraphs with browser validation.

**Skills:**
- `design-analyzer` - Extract technical specs from design references
- `design-to-wp-block` - Create WordPress block pattern
- `design-to-drupal-paragraph` - Create Drupal paragraph type
- `responsive-styling` - Mobile-first responsive CSS/SCSS (WCAG AA)
- `browser-validator` - Validate implementation in Chrome
- `drupal-sdc-twig` - Best practices for Drupal Single Directory Components (Twig)

### Development Workflow
Parallel work with git worktrees and safe changes to Composer-managed dependencies.

**Skills:**
- `worktree-manager` - Create, list, and tear down git worktrees (Kanopi branch conventions, DDEV isolation)
- `composer-patch-generator` - Generate and maintain CI-safe patches for Composer packages (cweagans/composer-patches)

### Drupal.org Contribution
Create issues and merge requests on drupal.org from your local environment.

**Skills:**
- `drupal-contribute` - Full contribution workflow (issue + merge request)
- `drupal-issue` - Create, update, and comment on drupal.org issues
- `drupal-mr` - Create merge requests via git.drupalcode.org
- `drupal-cleanup` - List and clean up cloned drupal.org repositories
- `drupalorg-contribution-helper` - Quick help with drupal.org git workflows
- `drupalorg-issue-helper` - Quick help with drupal.org issue templates

### WordPress
- `wp-add-skills` - Install official WordPress agent-skills

### Documentation
API docs, user guides, developer documentation, changelogs.

**Skill:**
- `documentation-generator` - Generate comprehensive documentation

**See [docs site](https://kanopi.github.io/cms-cultivator/) for complete skill reference and usage examples.**

---

## Architecture

### Specialist Agents

Skills spawn specialized agents for focused work:

**Generation Agents:**
- design-specialist, responsive-styling-specialist, documentation-specialist, testing-specialist

**Browser Validation:**
- browser-validator-specialist

**Drupal.org Contribution:**
- drupalorg-issue-specialist, drupalorg-mr-specialist

PR workflows (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`) run directly from the main session without an orchestrator agent — each skill contains its complete workflow.

### Agent Skills

Model-invoked skills that activate during conversation, across Claude Code, Claude Desktop, and OpenAI Codex:
- **PR & development workflow:** commit-message-generator, pr-create, pr-review, pr-release, worktree-manager, composer-patch-generator
- **Testing & code quality:** code-standards-checker, test-scaffolding, test-plan-generator, coverage-analyzer, documentation-generator
- **Design-to-code:** design-analyzer, design-to-wp-block, design-to-drupal-paragraph, responsive-styling, browser-validator, drupal-sdc-twig
- **Drupal.org contribution:** drupal-contribute, drupal-issue, drupal-mr, drupal-cleanup, drupalorg-contribution-helper, drupalorg-issue-helper
- **WordPress:** wp-add-skills

### How It Works

```
pr-create skill (main session)
    ├─→ Analyzes git changes
    ├─→ Reviews test coverage inline
    ├─→ Checks security concerns inline
    ├─→ Checks accessibility concerns inline
    ↓
Unified PR description → user approval → gh pr create

design-to-wp-block skill (main session)
    ├─→ Spawns design-specialist (extract specs, generate block pattern)
    ├─→ Spawns responsive-styling-specialist (mobile-first CSS)
    ├─→ Spawns browser-validator-specialist (real-browser validation)
    ↓
Validated block pattern + annotated screenshots
```

---

## Kanopi Integration

Integrates with [Kanopi's DDEV add-ons](https://kanopi.github.io/cms-cultivator/kanopi-tools/overview/) for:
- Composer scripts (code-check, phpstan, rector)
- DDEV commands (theme-build, cypress-run, critical-run)
- Drupal and WordPress project standards

---

## Requirements

**Required:**
- Claude Code CLI **or** OpenAI Codex
- Git

**Optional:**
- GitHub CLI (`gh`) - For PR skills
- DDEV - For Kanopi projects
- Chrome browser - For design validation skills

---

## Learn More

Visit the [complete documentation](https://kanopi.github.io/cms-cultivator/) for:
- Detailed skill reference with examples
- Agent and skill descriptions
- Platform-specific features (Drupal/WordPress)
- Kanopi integration guides
- Best practices and troubleshooting

---

## Contributing

Contributions welcome! See [Contributing Guide](https://kanopi.github.io/cms-cultivator/contributing/).

---

## License

GPL-2.0-or-later - see [LICENSE](LICENSE.md) for details.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Docs**: [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

---

**Created and maintained by [Kanopi Studios](https://kanopi.com)**
