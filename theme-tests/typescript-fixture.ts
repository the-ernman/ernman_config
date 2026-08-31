// --- 1. file-level doc comment ---
/**
 * TypeScript syntax-highlighting fixture.
 *
 * Exercises the full token surface: keywords, declarations, generics,
 * decorators, literals and operators. Sections are ordered identically
 * across every fixture in this directory.
 *
 * @packageDocumentation
 */

// --- 2. imports / modules ---
import { EventEmitter } from "node:events";
import type { Readable } from "node:stream";

export namespace units {
  export const SCALE = 1.5;
}

// --- 3. constants & statics ---
const MAX_RETRIES: number = 0x1f;
const FLAG_MASK = 0b1010_0110;
const THRESHOLD = 1_250.75;
const DEFAULT_PREFIX = "hello" as const;
const TOKEN_RE = /^[a-z_]\w*(\.\w+)*$/gi;
let counter: bigint = 0n;
var legacy: unknown = undefined;

// --- 4. type declarations ---
/** Run modes understood by the fixture. */
export enum Mode {
  Idle = 0,
  Run = 1,
  Halt = 2,
}

/** Anything that can render a salutation. */
export interface Greeter {
  readonly label: string;
  greet(name: string): Promise<string>;
}

export type Handler<T> = (payload: T) => void;
export type Route = `/${string}`;
export type Maybe<T> = T | null | undefined;
export type Source = Readable | null;

export class Config implements Greeter {
  static readonly kind = "config";
  readonly label: string = "config";
  #secret = "hidden";

  constructor(
    public prefix: string = DEFAULT_PREFIX,
    private count: number = 2,
    protected active: boolean = true,
    public mode: Mode = Mode.Idle,
  ) {}

  async greet(name: string): Promise<string> {
    const label = name.trim();
    if (!label) throw new Error("empty input");
    return `${this.prefix}, ${label} x${this.count} (${this.#secret}/${this.active})`;
  }
}

// --- 5. decorated / annotated declaration ---
function traced<This, Args extends unknown[], Return>(
  target: (this: This, ...args: Args) => Return,
  context: ClassMethodDecoratorContext,
): (this: This, ...args: Args) => Return {
  return function (this: This, ...args: Args): Return {
    console.log(`call ${String(context.name)}`);
    return target.call(this, ...args);
  };
}

export class Runner {
  static counter = 0;

  @traced
  bump(step = 1): number {
    Runner.counter += step;
    return Runner.counter;
  }

  get ready(): boolean {
    return Runner.counter >= 0;
  }
}

// --- 6. generic function with constraints ---
/** Folds a readonly list of numbers onto `start`. */
export function total<T extends number>(values: readonly T[], start: number): number {
  let acc = start;
  for (const value of values) {
    acc += value;
  }
  return acc;
}

// --- 7. parameters, control flow, operators ---
export async function process(
  cfg: Config,
  names: string[] = [],
  { limit = MAX_RETRIES, verbose = false }: { limit?: number; verbose?: boolean } = {},
  ...rest: number[]
): Promise<number> {
  let count = 0;
  let fallback: number | null = null;

  outer: for (let i = 0; i < names.length; i++) {
    const name = names[i];
    if (limit > 0 && i >= limit) break outer;
    if (!name || cfg.mode === Mode.Halt) continue outer;
    count += (i & 0x0f) | (1 << 2);
    count -= i >>> 1;
  }

  switch (cfg.mode) {
    case Mode.Run:
      count *= 2;
      break;
    case Mode.Halt:
      count = -count;
      break;
    default:
      fallback ??= 0;
  }

  const maybe: Maybe<string> = null;
  const resolved = maybe?.toUpperCase() ?? "none";

  try {
    if (count > THRESHOLD) throw new RangeError("too large");
    await Promise.resolve(count);
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : String(err));
  } finally {
    console.debug(resolved, rest.length, verbose, fallback);
  }

  do {
    count = Math.floor(count / 2);
  } while (count > 1_000);

  return count;
}

// --- 8. strings, numbers, escapes, regex ---
function literals(): void {
  const raw = String.raw`raw \n stays literal`;
  const quoted = "tab:\tnewline:\nunicode:\u2713 wide:\u{1F600}";
  const single = 'single "quoted" inner';
  const templated = `${DEFAULT_PREFIX} scaled by ${units.SCALE}`;
  const [hex, bin, sci] = [0xdead_beef, 0b1011, 6.022e23];
  const flags = FLAG_MASK ^ 0b0000_1111;
  const matched = TOKEN_RE.test("alpha.beta");
  const shape = { prefix: DEFAULT_PREFIX, count: 2, active: true } satisfies Record<string, unknown>;

  console.log(raw, quoted, single, templated, hex, bin, sci, flags, matched);
  console.log(shape.prefix, Config.kind, counter, legacy === undefined, null, false);
  // TODO: add JSX coverage in a dedicated .tsx fixture.
}

// --- 9. entrypoint ---
async function main(): Promise<void> {
  const cfg = new Config(DEFAULT_PREFIX, 2, true, Mode.Run);
  const bus = new EventEmitter();
  const onRoute: Handler<Route> = (route) => void bus.emit("route", route);

  literals();
  counter += 1n;
  onRoute("/index");
  console.log(await cfg.greet("typist"), new Runner().bump(3), total([1, 2, 3], 0));
  console.log(await process(cfg, ["a", "", "c"], { verbose: true }, 1, 2));
}

void main();
