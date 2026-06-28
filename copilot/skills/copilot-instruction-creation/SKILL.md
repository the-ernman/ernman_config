---
name: copilot-instruction-creation
description: Writing .github/copilot-instructions.md files for repositories. Activate when setting up repo-level Copilot instructions.
---

# Copilot Instructions File

## Location

`.github/copilot-instructions.md` — loaded into context on EVERY Copilot request in the repo.

## Purpose

Repo-specific rules Copilot follows automatically. Brevity = cost savings (tokens consumed per interaction).

## What Belongs

- Project conventions: language, framework, key patterns
- Build/test/run commands (exact invocations)
- Architecture overview (3-5 bullets max)
- Naming conventions specific to this project
- Preferred libraries/tools and versions
- Anti-patterns: what NOT to do in this codebase

## What Does NOT Belong

- Generic coding advice (Copilot already knows)
- Lengthy tutorials or documentation
- Secrets, credentials, or sensitive internal paths
- Rules already enforced by linters/formatters (redundant)

## Structure Rules

- Under 100 lines total
- Bullets, not prose
- Group by topic with `##` headers
- No YAML frontmatter needed (GitHub reads it as-is)
- Most important rules first

## Template

```markdown
## Project

- Language: X, Framework: Y
- Build: `command`
- Test: `command`
- Run: `command`

## Conventions

- [naming, patterns, structure rules]

## Do NOT

- [project-specific anti-patterns]
```
