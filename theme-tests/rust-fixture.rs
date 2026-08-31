// --- 1. file-level doc comment ---

//! Rust syntax-highlighting fixture. Exercises the full token surface:
//! keywords, declarations, generics, lifetimes, macros, literals, operators.
//! Sections are ordered identically across every fixture in this directory.

#![allow(dead_code, unused_variables)]

// --- 2. imports / modules ---

use std::collections::HashMap;
use std::fmt::{self, Display, Formatter};

mod units {
    pub const SCALE: f64 = 1.5;
}

// --- 3. constants & statics ---

const MAX_RETRIES: u32 = 0x1F;
const FLAG_MASK: u8 = 0b1010_0110;
const THRESHOLD: f64 = 1_250.75;
static DEFAULT_PREFIX: &str = "hello";
static TOKEN_PATTERN: &str = r"^[a-z_]\w*(\.\w+)*$";

// --- 4. type declarations ---

/// Run modes understood by the fixture.
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Mode {
    Idle,
    Run { steps: usize },
    Halt(i32),
}

/// Failure returned when a name is blank.
#[derive(Debug, Default)]
pub struct GreetError;

impl Display for GreetError {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "empty input")
    }
}

/// Anything that can render a salutation.
pub trait Greeter {
    /// Greets `name`, failing when it is blank.
    fn greet(&self, name: &str) -> Result<String, GreetError>;

    fn label(&self) -> &'static str {
        "greeter"
    }
}

#[derive(Debug)]
pub struct Config<'a> {
    pub prefix: &'a str,
    pub count: usize,
    pub active: bool,
    mode: Mode,
}

type Registry = HashMap<String, Vec<u8>>;

// --- 5. decorated / annotated declaration ---

impl<'a> Greeter for Config<'a> {
    #[inline]
    fn greet(&self, name: &str) -> Result<String, GreetError> {
        let label = name.trim();
        if label.is_empty() {
            return Err(GreetError);
        }
        Ok(format!("{}, {} x{}", self.prefix, label, self.count))
    }
}

// --- 6. generic function with constraints ---

/// Folds a slice of addable values onto their default.
pub fn sum<T>(values: &[T]) -> T
where
    T: Copy + Default + std::ops::Add<Output = T>,
{
    let mut total = T::default();
    for &value in values {
        total = total + value;
    }
    total
}

// --- 7. parameters, control flow, operators ---

fn process(cfg: &Config<'_>, names: &[&str], limit: usize) -> i64 {
    let mut count: i64 = 0;
    let mut registry: Registry = Registry::new();
    let scale = |value: f64, factor: f64| -> f64 { value * factor };

    'outer: for (index, name) in names.iter().enumerate() {
        if limit > 0 && index >= limit {
            break 'outer;
        }
        if name.is_empty() || !cfg.active {
            continue 'outer;
        }
        count += (index as i64 & 0x0F) | (1 << 2);
        count -= (index as i64) >> 1;
        registry.insert((*name).to_string(), vec![FLAG_MASK; 2]);
    }

    match cfg.mode {
        Mode::Idle => count *= 2,
        Mode::Run { steps } => count += steps as i64,
        Mode::Halt(code) if code != 0 => count = -count,
        _ => {}
    }

    while count > MAX_RETRIES as i64 {
        count /= 2;
    }

    let maybe: Option<&str> = None;
    if let Some(text) = maybe {
        println!("{text}");
    }
    count + scale(THRESHOLD, units::SCALE) as i64
}

// --- 8. strings, numbers, escapes, regex ---

fn literals() {
    let raw = r"raw \n stays literal";
    let quoted = "tab:\tnewline:\nunicode:\u{2713}";
    let byte = b'\x41';
    let wide = '\u{1F600}';
    let (hex, bin, sci) = (0xDEAD_BEEFu32, 0b1011u8, 6.022e23_f64);
    let flags = FLAG_MASK ^ 0b0000_1111;

    println!("{raw} | {quoted} | {byte} | {wide}");
    println!("{}|{}|{}|{}|{:?}", hex, bin, sci, flags, Option::<u8>::None);
    println!("{TOKEN_PATTERN} => {} {}", true, false);
    // TODO: add async examples once a runtime dependency is allowed.
}

// --- 9. entrypoint ---

fn main() {
    let cfg = Config {
        prefix: DEFAULT_PREFIX,
        count: 2,
        active: true,
        mode: Mode::Run { steps: 3 },
    };

    literals();
    let total = sum(&[1.5_f64, 2.5, THRESHOLD]);
    println!("{} {} {total}", cfg.label(), process(&cfg, &["a", "", "c"], 8));

    match cfg.greet("rustacean") {
        Ok(message) => println!("{message}"),
        Err(error) => eprintln!("{error}"),
    }
}
