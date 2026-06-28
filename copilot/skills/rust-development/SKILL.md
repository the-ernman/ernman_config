---
name: rust-development
description: Rust language expertise for writing safe, performant, production-quality Rust code. Primary language for the Loom project. Use for Rust development, ownership patterns, error handling, async/await, cargo management, CLI tools, and serialization.
---

## Project Conventions

### Cargo / Workspace

- Edition 2021+, always specify `rust-version`; workspace layout: `Cargo.toml` ([workspace]) + `crates/*/`
- Share dependency versions via `[workspace.dependencies]`
- Use features for optional functionality; keep default features minimal

### Tooling

- `cargo fmt` — format before committing; rustfmt defaults
- `cargo clippy` — warnings as errors; fix all lints
- `cargo llvm-cov` — aim for high coverage on public API

### Preferred Crates

| Purpose | Crate |
|---------|-------|
| Errors (library) | `thiserror` |
| Errors (binary) | `anyhow` |
| Serialization | `serde` + `serde_json` / `toml` |
| Async runtime | `tokio` |
| CLI args | `clap` (derive) |
| Benchmarks | `criterion` |
| Mocking | `mockall` |

## Rules

### Error Handling
- Library crates: error enums with `thiserror`; binary crates: `anyhow::Result` + `.context()`
- `unwrap()` only in tests, examples, and provably-infallible spots
- Never silently discard `#[must_use]` / `Result` values

### Ownership & Performance
- No unnecessary `.clone()`; prefer borrowing or restructuring
- Prefer `&[T]` over `&Vec<T>`, `&str` over `&String` in signatures
- Iterator chains over manual `for` loops with accumulators
- No `unsafe` without a `// SAFETY:` comment and proven necessity

### Code Style
- Derive order: `Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize`
- Group imports: std → external → crate/super/self
- Prefer newtype pattern over type aliases for domain concepts
- Exhaustive `match`; avoid wildcard `_` on enums unless future-proofing

### Async
- Default to `tokio`; use `#[tokio::main]` / `#[tokio::test]`
- Prefer `tokio::spawn` for concurrency; never block in async context
- Use `tokio::sync` primitives (Mutex, RwLock, mpsc) inside async code

### Testing
- Unit tests in `#[cfg(test)] mod tests` at bottom of file; integration tests in `tests/`
- Use `assert_eq!` / `assert_matches!` with descriptive messages
- Property-based testing with `proptest` where applicable
