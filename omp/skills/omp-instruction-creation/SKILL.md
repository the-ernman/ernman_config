---
name: omp-instruction-creation
description: Writing omp AGENTS.md and RULES.md context files. Activate when setting up user-level or repo-level omp instructions.
---

# omp Instruction Files

## Location

- `~/.omp/agent/AGENTS.md` — user-level context, loaded into every session.
- `<repo>/.omp/AGENTS.md` — project context, loaded for that repo (nearest non-empty `.omp/` walking up to the repo root).
- `AGENTS.md`/`RULES.md` must live in a non-empty `.omp/` directory to load.

## AGENTS.md vs RULES.md

| File | Use for | Behavior |
|------|---------|----------|
| `AGENTS.md` | Broad, durable background: conventions, build/test commands, architecture | Loaded once into the opening `<context>` block |
| `RULES.md` | A handful of short, hard requirements | Loaded as an always-apply sticky rule, re-attached near the current turn |

Keep `RULES.md` short — sticky content costs budget on every turn. Long background belongs in `AGENTS.md`, where it costs budget once.

## What Belongs in AGENTS.md

- Project conventions: language, framework, key patterns
- Build/test/run commands (exact invocations)
- Architecture overview (3-5 bullets max)
- Naming conventions specific to this project
- Preferred libraries/tools and versions
- Anti-patterns: what NOT to do in this codebase

## What Does NOT Belong

- Generic coding advice (the model already knows)
- Lengthy tutorials or documentation
- Secrets, credentials, or sensitive internal paths
- Rules already enforced by linters/formatters (redundant)

## Structure Rules

- Bullets, not prose; group by topic with `##` headers
- Most important rules first
- `@path` tokens inline-expand a referenced file before injection

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
