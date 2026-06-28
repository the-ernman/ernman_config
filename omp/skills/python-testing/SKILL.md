---
name: python-testing
description: Python-specific testing practices with pytest, fixtures, mocking, async testing, coverage configuration, and uv execution rules. Activate when working with pytest files, conftest.py, test directories, pyproject.toml testing configuration, or Python test-related tasks.
---

# Python Testing Rules

## Configuration

- `pyproject.toml` should have a `[tool.pytest.ini_options]` section with:
  - `testpaths = ["tests"]`
  - `python_files = ["test_*.py"]`
  - `addopts = "--cov=src --cov-report=term-missing"`

## Execution

- Run tests: `uv run pytest`
- Run single: `uv run pytest tests/path/test_file.py::test_name -v`
- With coverage: `uv run pytest --cov=src --cov-report=term-missing`

## Structure

- Tests in `tests/` mirroring `src/` layout; files named `test_<module>.py`
- Shared fixtures in `conftest.py` at appropriate directory level; one per level as needed

## Patterns

- AAA pattern: Arrange, Act, Assert — one logical assert per test
- Use `pytest-mock` (mocker fixture); mock where symbol is **imported into**, not where defined
- Async tests: `@pytest.mark.asyncio`
- Parametrize for input variations; keep test body identical across cases

## Fixtures

- Default scope `function`; use `session` only for expensive setup (DB, containers)
- Prefer factory fixtures over complex parameterized fixtures
- Use `tmp_path` for filesystem tests, not manual tempfile

## Anti-Patterns

- No test logic (no if/else/loops in tests)
- No sleeping; mock time or use async wait
- Don't test private methods; test through public interface
