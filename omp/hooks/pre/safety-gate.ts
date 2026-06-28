import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

// Mirrors the copilot safety-gate: flag obviously destructive shell commands and
// require human confirmation before they run. Interactive sessions get a confirm
// dialog; headless/subagent runs (no UI to ask) fail closed and block.
const DANGEROUS_PATTERNS: RegExp[] = [
	/\brm\s+-rf\s+\//,
	/\brm\s+-rf\s+\*/,
	/\bDROP\s+TABLE\b/i,
	/\bDROP\s+DATABASE\b/i,
	/\bTRUNCATE\b/i,
	/--no-verify\b/,
	/\bforce[-\s]push\b/i,
	/--force\b/,
	/\bchmod\s+777\b/,
	/\bcurl\b[^\n]*\|\s*sh\b/,
	/\bwget\b[^\n]*\|\s*sh\b/,
];

export default function safetyGate(omp: HookAPI): void {
	omp.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return;

		const cmd = String(event.input?.command ?? "");
		const hit = DANGEROUS_PATTERNS.find(re => re.test(cmd));
		if (!hit) return;

		const reason = `Potentially destructive command blocked by safety-gate (matched ${hit}). Review carefully before re-running.`;

		if (ctx.hasUI) {
			const allow = await ctx.ui.confirm(
				"Dangerous command",
				`This command looks destructive:\n\n${cmd}\n\nProceed?`,
			);
			if (allow) return;
		}

		return { block: true, reason };
	});
}
