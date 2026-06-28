---
name: go-testing
description: Go testing practices with stdlib testing, testify, table-driven tests, and mocking. Activate for Go test files (*_test.go), testing utilities, or test configuration.
---

# Go Testing Rules

## Execution

- Run all: `go test ./...`
- Run specific: `go test -v -run TestFunctionName ./path/to/pkg`
- With coverage: `go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out`
- Race detection: `go test -race ./...`
- Short mode: `go test -short ./...` (skip slow tests)
- Benchmarks: `go test -bench=. -benchmem ./...`

## Structure

- Test files: `<file>_test.go` in the same package
- Black-box tests: use `package foo_test` to test only exported API
- White-box tests: use `package foo` for internal testing
- Test helpers in `testdata/` or `_test.go` files; never in production code
- Shared fixtures: `testdata/` directory (auto-ignored by go tooling)

## Patterns

### Table-Driven Tests (default pattern)
- Use `[]struct{ name string; ... }` for test cases
- `t.Run(tc.name, func(t *testing.T) { ... })` for subtests
- One logical assertion per subtest
- Test name format: `Test<Function>_<scenario>`

### Rules
- Use `testify/assert` for assertions (cleaner than manual `if` checks)
- Use `testify/require` when test cannot continue after failure
- Use `t.Helper()` in test helper functions
- Use `t.Parallel()` for independent tests; default to parallel
- Use `t.Cleanup()` for teardown instead of defer when possible
- Never use `os.Exit` or `log.Fatal` in tests

## Mocking

- Use `mockery` to generate mocks from interfaces
- Mock at interface boundaries; design for testability
- For HTTP: `httptest.NewServer` for integration, `httptest.NewRecorder` for handlers
- For DB: use interfaces + mock implementation, or `testcontainers-go` for integration

## Test Fixtures

- `TestMain(m *testing.M)` for package-level setup/teardown
- `testdata/` for static files (JSON fixtures, golden files)
- Golden file testing: compare output against `testdata/*.golden`; update with `-update` flag
- `t.TempDir()` for filesystem tests (auto-cleaned)

## Edge Cases to Always Cover

- `nil` inputs (slices, maps, pointers)
- Empty slices/maps vs nil slices/maps (they differ in Go)
- Zero values for all types
- Context cancellation
- Concurrent access (test with `-race`)
- Error paths (not just happy path)

## Anti-Patterns

- No `time.Sleep` in tests; use channels, tickers, or `testing.Short()`
- No test interdependence; each test must be independently runnable
- No assertions in test helpers (use `t.Helper()` + `t.Fatal`)
- No global state mutation between tests
- No ignoring `-race` failures
