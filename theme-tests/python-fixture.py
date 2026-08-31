# --- 1. file-level doc comment ---
"""Python syntax-highlighting fixture.

Exercises the full token surface: keywords, declarations, generics, decorators,
literals and operators. Sections are ordered identically across every fixture.
"""

# --- 2. imports / modules ---
from __future__ import annotations

import re
from dataclasses import dataclass, field
from enum import Enum
from functools import wraps
from typing import Protocol, TypeVar

# --- 3. constants & statics ---
MAX_RETRIES: int = 0x1F
FLAG_MASK: int = 0b1010_0110
THRESHOLD: float = 1_250.75
DEFAULT_PREFIX: str = "hello"
VERBOSE: bool = True
MISSING = None
TOKEN_RE = re.compile(r"^[a-z_]\w*(\.\w+)*$")

T = TypeVar("T", int, float)


# --- 4. type declarations ---
class Mode(Enum):
    """Run modes understood by the fixture."""

    IDLE = 0
    RUN = 1
    HALT = 2


class Greeter(Protocol):
    """Anything that can render a salutation."""

    def greet(self, name: str) -> str: ...


@dataclass(slots=True)
class Config:
    """Runtime settings."""

    prefix: str = DEFAULT_PREFIX
    count: int = 2
    active: bool = True
    mode: Mode = Mode.IDLE
    tags: list[str] = field(default_factory=list)

    def greet(self, name: str) -> str:
        """Greet *name*, failing when it is blank."""
        label = name.strip()
        if not label:
            raise ValueError("empty input")
        return f"{self.prefix}, {label} x{self.count}"


# --- 5. decorated / annotated declaration ---
def traced(func):
    """Count and log every call to *func*."""
    calls = 0

    @wraps(func)
    def wrapper(*args, **kwargs):
        nonlocal calls
        calls += 1
        print(f"call {func.__name__!r} #{calls}")
        return func(*args, **kwargs)

    return wrapper


class Runner:
    counter: int = 0

    @staticmethod
    @traced
    def bump(step: int = 1) -> int:
        Runner.counter += step
        return Runner.counter

    @property
    def ready(self) -> bool:
        return Runner.counter >= 0


# --- 6. generic function with constraints ---
def total(values: list[T], start: T) -> T:
    """Fold *values* onto *start*."""
    acc = start
    for value in values:
        acc += value
    return acc


# --- 7. parameters, control flow, operators ---
async def process(cfg: Config, *names: str, limit: int = MAX_RETRIES, **extra: object) -> float:
    global VERBOSE
    count = 0
    for index, name in enumerate(names):
        if limit > 0 and index >= limit:
            break
        if not name or not cfg.active:
            continue
        count += (index & 0x0F) | (1 << 2)
        count -= index >> 1
    else:
        VERBOSE = False

    match cfg.mode:
        case Mode.RUN:
            count *= 2
        case Mode.HALT if count > 0:
            count = -count
        case _:
            pass

    try:
        result = await _resolve(cfg, count)
    except (ValueError, TypeError) as err:
        print(f"failed: {err}")
        result = MISSING
    finally:
        print("done", extra is not None, VERBOSE)

    while (chunk := count // 2) > THRESHOLD:
        count = chunk
    return count if result is None else count + 1


async def _resolve(cfg: Config, count: int) -> str | None:
    return cfg.greet("pythonista") if count else None


# --- 8. strings, numbers, escapes, regex ---
def literals() -> None:
    raw = r"raw \n stays literal"
    quoted = "tab:\tnewline:\nunicode:\u2713 wide:\U0001f600"
    single = 'single "quoted" inner'
    triple = """multi
line"""
    hex_value, binary, sci = 0xDEAD_BEEF, 0b1011, 6.022e23
    flags = FLAG_MASK ^ 0b0000_1111
    matched = TOKEN_RE.match("alpha.beta")

    print(f"{raw} | {quoted!s} | {single} | {triple}")
    print(hex_value, binary, sci, flags, True, False, None, matched is not None)
    print(b"bytes\x41", f"{THRESHOLD:>10.2f}")
    # TODO: exercise typing.Generic once a mypy config lands.


# --- 9. entrypoint ---
def main() -> None:
    cfg = Config(prefix=DEFAULT_PREFIX, count=2, active=VERBOSE, mode=Mode.RUN)
    greeter: Greeter = cfg

    literals()
    print(Runner.bump(step=3), Runner().ready, total([1.5, 2.5], 0.0))
    print(greeter.greet("pythonista"), cfg.tags == [], process is not MISSING)


if __name__ == "__main__":
    main()
