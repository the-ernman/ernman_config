---
name: go-development
description: Go development best practices and project conventions. Use for Go projects, APIs, CLI tools, or microservices.
---

# Go Development

## Tooling

- `go fmt` — always format; non-negotiable
- `golangci-lint` — primary linter; run with `golangci-lint run ./...`
- `go vet` — static analysis; catches common mistakes
- `go test -cover` — coverage reporting
- Default to latest stable Go version for new projects

## Commands

```bash
go mod init <module-path>         # New project
go mod tidy                       # Clean dependencies
go run .                          # Run main package
go build ./...                    # Build all packages
go test ./...                     # Test all packages
go test -v -run TestName ./pkg    # Run specific test
golangci-lint run ./...           # Lint
```

## Project Layout

- Follow standard Go project layout:
  ```
  cmd/<app-name>/main.go    # Entry points
  internal/                 # Private packages (not importable)
  pkg/                      # Public library packages (if applicable)
  ```
- `internal/` for application-specific code; enforces import boundary
- One package per directory; package name matches directory name
- `main` package only in `cmd/`; keep it thin (wire up dependencies, call run)

## Rules

### Error Handling
- Always check errors; never use `_` to discard errors
- Wrap errors with context: `fmt.Errorf("doing X: %w", err)`
- Define sentinel errors with `errors.New` for expected conditions
- Use `errors.Is` / `errors.As` for error inspection
- Return errors; don't panic (panic only for truly unrecoverable programmer bugs)

### Code Style
- Accept interfaces, return structs
- Keep interfaces small (1-3 methods); define at consumer side
- Prefer composition over inheritance (embedding)
- No init() functions unless absolutely necessary
- Context (`context.Context`) as first parameter for cancellable/timed operations
- Use named return values sparingly; only when it aids readability

### Concurrency
- Use goroutines + channels for concurrent work
- Always handle goroutine lifecycle (use `sync.WaitGroup` or `errgroup`)
- Never launch goroutines without a way to shut them down
- Prefer `sync.Mutex` for simple shared state; channels for communication
- Use `context.Context` for cancellation propagation

### Dependencies
- Minimal external dependencies; stdlib is rich — use it
- `go mod tidy` before every commit
- Vendor only when reproducibility requires it (`go mod vendor`)

### Naming
- Packages: short, lowercase, single-word (no underscores, no mixedCaps)
- Exported: PascalCase; unexported: camelCase
- Interfaces: single-method interfaces named with -er suffix (Reader, Writer, Closer)
- Avoid stuttering: `http.Client` not `http.HTTPClient`

## Preferred Libraries

| Purpose | Package |
|---------|---------|
| CLI | `cobra` + `viper` |
| HTTP router | `chi` or stdlib `net/http` (1.22+ with routing) |
| Logging | `slog` (stdlib, Go 1.21+) |
| Config | `viper` or env vars directly |
| Testing | stdlib `testing` + `testify` |
| Mocking | `mockery` (generates from interfaces) |
| DB | `sqlx` or `pgx` |
| Errors | stdlib `errors` + `fmt.Errorf` with `%w` |
