// --- 1. file-level doc comment ---

// Package main is a syntax-highlighting fixture. It exercises the full Go
// token surface: keywords, declarations, generics, literals and operators.
// Sections are ordered identically across every fixture in this directory.
package main

// --- 2. imports / modules ---

import (
	"errors"
	"fmt"
	"regexp"
	"strings"
)

// --- 3. constants & statics ---

// Mode enumerates the supported run modes.
type Mode int

const (
	ModeIdle Mode = iota // zero value
	ModeRun
	ModeHalt
)

const (
	MaxRetries    int     = 0x1F
	Threshold     float64 = 1_250.75
	FlagMask      uint8   = 0b1010_0110
	DefaultPrefix string  = "hello"
	Verbose       bool    = true
)

var (
	ErrEmpty                   = errors.New("empty input")
	tokenRe                    = regexp.MustCompile(`^[a-z_]\w*(\.\w+)*$`)
	registry map[string][]byte = nil
)

// --- 4. type declarations ---

// Greeter renders a salutation for a name.
type Greeter interface {
	Greet(name string) (string, error)
}

// Config holds runtime settings.
type Config struct {
	Prefix string `json:"prefix"`
	Count  int    `json:"count,omitempty"`
	Active bool   `json:"-"`
	mode   Mode
}

// Handler consumes a payload and reports failure.
type Handler func(payload string) error

// Numeric constrains the generic fold below.
type Numeric interface {
	~int | ~int64 | ~float64
}

// --- 5. decorated / annotated declaration ---

//go:noinline
func (c *Config) Greet(name string) (string, error) {
	label := strings.TrimSpace(name)
	if label == "" {
		return "", ErrEmpty
	}
	return fmt.Sprintf("%s, %s x%d", c.Prefix, label, c.Count), nil
}

// --- 6. generic function with constraints ---

// Sum folds a slice of numeric values onto their zero value.
func Sum[T Numeric](values []T) T {
	var total T
	for _, value := range values {
		total += value
	}
	return total
}

// --- 7. parameters, control flow, operators ---

func process(cfg Config, names []string, limit int) (count int) {
	defer func() { _ = recover() }()

	done := make(chan struct{}, 1)
	go func() { done <- struct{}{} }()

outer:
	for index, name := range names {
		switch {
		case limit > 0 && index >= limit:
			break outer
		case name == "" || !cfg.Active:
			continue outer
		default:
			count += index&0x0F | 1<<2
			count -= index >> 1
		}
	}

	select {
	case <-done:
		count *= 2
	default:
		count /= 1
	}

	if msg, err := cfg.Greet("gopher"); err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(msg, registry == nil)
	}
	return count
}

// --- 8. strings, numbers, escapes, regex ---

func literals() {
	raw := `raw \n stays literal`
	quoted := "tab:\tnewline:\nunicode:\u2713 wide:\U0001F600"
	char := '\n'
	hex, bin, sci := 0xDEAD_BEEF, 0b1011, 6.022e23
	flags := FlagMask ^ 0b0000_1111
	fmt.Printf("%s|%s|%q|%d|%d|%g|%d|%t|%v\n", raw, quoted, char, hex, bin, sci, flags, false, nil)
	fmt.Println(tokenRe.MatchString("alpha.beta"), strings.Repeat("=", 8), Threshold)
	// TODO: cover struct embedding in a later revision.
}

// --- 9. entrypoint ---

func main() {
	cfg := Config{Prefix: DefaultPrefix, Count: 2, Active: Verbose, mode: ModeRun}
	var greeter Greeter = &cfg
	var handler Handler = func(payload string) error { return nil }

	literals()
	_ = handler("payload")
	msg, _ := greeter.Greet("gopher")
	fmt.Println(msg, cfg.mode == ModeHalt, process(cfg, []string{"a", "", "c"}, MaxRetries), Sum([]float64{1.5, 2.5}))
}
