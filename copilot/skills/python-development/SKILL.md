---
name: python-development
description: Modern Python development and production best practices. Use for Python projects, APIs, data processing, or automation scripts.
---

# Python Development

## Tooling

- `uv` exclusively for package/env management
- `ruff` for linting + formatting
- `pytest` + `pytest-cov` for testing
- `ty` for type checking
- Default Python 3.12 for new projects

## Configuration

`pyproject.toml`: `[tool.ruff]` line-length=88, target-version=py312; `[tool.pytest.ini_options]` testpaths=["tests"], addopts="--cov=src --cov-report=term-missing"; `[tool.ty]` python_version=3.12, strict=true

## uv Commands

```bash
uv init --python 3.12       # New project
uv sync                     # Install from pyproject.toml
uv add <package>            # Add dependency
uv run pytest               # Run tests in venv
uv run python script.py     # Run in venv
```

## Project Preferences

- src layout: `src/<package_name>/`
- Prefer `pathlib.Path` over `os.path`
- Dataclasses or Pydantic for structured data; Pydantic for validation
- Design for testability; avoid patterns that resist mocking
- Network/API calls must have retries
- Avoid global state and configuration singletons

## Preferred Libraries

- CLI: `click`
- Data validation / models: `pydantic`, `pydantic-settings`
- HTTP client: `httpx`
- API framework: `sanic`
- Database: `sqlalchemy` 2.0+
- Retry/resilience: `tenacity`

## Imports

- Group: stdlib → third-party → local (blank line between). Prefer absolute imports.
- One `import` per line; multiple names from same module on one `from` line is fine.

## Naming

- Packages/modules: short, all lowercase
- Classes: CapitalWords; functions/variables: snake_case

## Rules

- Type hints required on all function signatures (args + return)
- Specific exception types only; never bare `except`
- Use stdlib `logging`; no `print()` for output
- Docstrings on all functions/classes; Google style
- Tests in `tests/` mirroring src structure
- async/await for I/O-bound operations only
