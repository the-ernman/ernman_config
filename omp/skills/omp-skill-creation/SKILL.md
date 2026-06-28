---
name: omp-skill-creation
description: Creating omp SKILL.md files. Activate when building reusable skills for ~/.omp/agent/skills/ or a project .omp/skills/ directory.
---

# omp Skill Creation

## File Location

`<skills-root>/<skill-name>/SKILL.md` — one skill per directory, discovered one level under `skills/` (non-recursive). User skills live in `~/.omp/agent/skills/`; project skills in `<repo>/.omp/skills/`.

## YAML Frontmatter (required)

| Field | Format | Purpose |
|-------|--------|---------|
| `name` | kebab-case | Short identifier matching the directory name |
| `description` | 1-2 sentences | Tells the agent WHEN to load the skill — this is the match signal |

`description` is required for native `.omp` discovery; without it the skill is dropped.

## Description Field (critical)

- Include trigger words and file patterns: "Activate when working with pytest files, conftest.py"
- Name tools/frameworks explicitly: "ansible-playbook, inventory files (.yml, .ini)"
- Be specific about scope — vague descriptions cause false matches or missed loads

## What Belongs in a Skill

- Domain knowledge the model lacks (project conventions, tool preferences, workflows)
- Concrete commands, rules, patterns
- Opinionated defaults and preferred libraries
- Anti-patterns specific to the domain

## What Does NOT Belong

- Things the model already knows (language syntax, stdlib, common patterns)
- Verbose examples when a one-line rule suffices
- Motivational text or "Remember:" paragraphs
- Information covered by other skills (no duplication)
- Templates the model can generate from a brief description
- Repo-wide rules (those go in `AGENTS.md`); hard non-negotiables (those go in `RULES.md`)

## Structure Rules

- Under 80 lines total
- Bullets, tables, short code blocks — no prose
- Group by topic with `##` headers
- Most impactful rules first
- No inline comments explaining rationale

## Referenced Assets

- Keep supporting files under the skill directory and read them with `skill://<name>/<path>`

## Anti-Patterns

- Don't create skills for single-project use — skills are cross-repo
- Don't duplicate what linters/formatters already enforce
- Don't wrap generic advice the model already provides well
- Don't add examples longer than 3 lines unless truly necessary
