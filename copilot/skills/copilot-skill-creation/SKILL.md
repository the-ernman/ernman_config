---
name: copilot-skill-creation
description: Creating VS Code Copilot SKILL.md files. Activate when building reusable skills for .copilot/skills/ or .github/copilot/skills/ directories.
---

# Copilot Skill Creation

## File Location

`<skills-dir>/<skill-name>/SKILL.md` — one skill per directory.

## YAML Frontmatter (required)

| Field | Format | Purpose |
|-------|--------|---------|
| `name` | kebab-case | Short identifier matching directory name |
| `description` | 1-2 sentences | Tells Copilot WHEN to activate — this is the match signal |

## Description Field (critical)

- Include trigger words and file patterns: "Activate when working with pytest files, conftest.py"
- Name tools/frameworks explicitly: "ansible-playbook, inventory files (.yml, .ini)"
- Be specific about scope — vague descriptions cause false matches or missed activations

## What Belongs in a Skill

- Domain knowledge the LLM lacks (project conventions, tool preferences, workflows)
- Concrete commands, rules, patterns
- Opinionated defaults and preferred libraries
- Anti-patterns specific to the domain

## What Does NOT Belong

- Things LLMs already know (language syntax, stdlib, common patterns)
- Verbose examples when a one-line rule suffices
- Motivational text or "Remember:" paragraphs
- Information covered by other skills (no duplication)
- Templates the LLM can generate from a brief description
- Repo-specific rules (those go in copilot-instructions.md)

## Structure Rules

- Under 80 lines total
- Bullets, tables, short code blocks — no prose
- Group by topic with `##` headers
- Most impactful rules first
- No inline comments explaining rationale

## Anti-Patterns

- Don't create skills for single-project use — skills are cross-repo
- Don't duplicate what linters/formatters already enforce
- Don't wrap generic advice the LLM already provides well
- Don't add examples longer than 3 lines unless truly necessary
