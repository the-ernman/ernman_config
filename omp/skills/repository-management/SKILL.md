---
name: repository-management
description: Repository setup, health standards, and automation. Activate when initializing repos, configuring CI, pre-commit hooks, or assessing project health.
---

# Repository Health

## Required Setup

Every repository must have:

- README.md with: purpose, setup instructions, usage, and contributing guidelines
- Linting configured and passing (ruff for Python, clippy for Rust, eslint for JS/TS, etc)
- Static type checking configured when available (ty for Python, tsc for TS, Rust compiler)
- Test framework configured with at least one passing test
- `.gitignore` appropriate for the language/framework
- `LICENSE` file

## Pre-commit Hooks (prek)

Use `prek`: pre-commit runs lint + format + type check; pre-push runs full test suite.
Hooks must pass before code leaves the developer's machine.

## Health Checklist

| Concern | Requirement |
|---------|-------------|
| Linting | Zero warnings; configured in CI and pre-commit |
| Formatting | Enforced automatically (ruff format, cargo fmt, prettier) |
| Type safety | Static analysis enabled; no untyped public APIs |
| Tests | Exist, pass, run on pre-push; coverage regressions flagged |
| Dependencies | Pinned/locked; audited for vulnerabilities |
| Secrets | No hardcoded secrets; use env vars or secret manager |

## README

README covers: name, prerequisites, setup, run, test, structure, contributing.

## Dependency Hygiene

- Lock files committed; audit regularly (`cargo audit`, `uv pip audit`)
- Minimal deps — no packages for trivial functionality
- Pin major versions; allow patch updates

## Branch Strategy

- `main` is always deployable
- Feature branches off main; short-lived
- PRs require passing CI (lint + types + tests)
- PRs require passing CI before merge
- No force-push to shared branches
