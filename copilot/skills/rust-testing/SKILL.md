---
name: rust-testing
description: Rust testing practices with cargo test, mockall, integration tests, and property testing. Activate for Rust test files, #[cfg(test)] modules, tests/ directories.
---

# Rust Testing Rules

## Execution

- Run all: `cargo test`
- Run specific: `cargo test test_name`
- Show output: `cargo test -- --nocapture`
- Run ignored: `cargo test -- --ignored`

## Structure

- Unit tests: `#[cfg(test)] mod tests` at bottom of each source file
- Integration tests: `tests/` directory at crate root (each file is separate crate)
- Shared helpers: `tests/common/mod.rs`

## Rules

- `#[test]` attribute; async tests use `#[tokio::test]`
- Arrange-Act-Assert; one logical assertion per test
- `assert_eq!(actual, expected, "context message")`
- Names: `test_<function>_<scenario>_<expected>`
- `#[should_panic(expected = "msg")]` for panic tests; `Result<()>` for `?` tests
- Mark slow tests `#[ignore]`; run in CI with `--ignored`

## Mocking

- `mockall` with `#[automock]` on trait boundaries
- Prefer dependency injection over global mocking
- Simple cases: hand-written test doubles > mockall complexity

## Fixtures

- Helper functions for setup; no built-in fixture system
- `LazyLock` / `once_cell::Lazy` for expensive one-time init
- `tempfile` for filesystem; `wiremock` for HTTP mocking

## Property Testing

- `proptest` for input-space exploration (parsers, serialization roundtrips, numerics)
- Define `proptest! {}` blocks alongside unit tests

## Coverage

- `cargo llvm-cov`; aim for high coverage on public API, don't chase 100% on internals

## Anti-Patterns

- No `#[cfg(test)]` on production code paths
- No sleeping; use `tokio::time::pause()` for time-dependent tests
- No tests depending on execution order
- No ignoring failures with `let _ =`
