# omp Config

Personal [oh-my-pi](https://github.com/can1357/oh-my-pi) (`omp`) configuration, modeled on the `copilot/` config in this repo.

## Layout

| Path | omp role |
|------|----------|
| `AGENTS.md` | User-level context loaded into every session (general working rules) |
| `RULES.md` | Sticky always-apply rules (hard style + safety non-negotiables) |
| `config.yml` | Full omp settings — model roles, token knobs, memory backend — shared across machines |
| `agents/*.md` | Model-routed specialist subagents (`coder`, `tester`, `security`, `docs`) filling gaps left by omp's bundled agents (`task`, `explore`, `plan`, `reviewer`, `oracle`, `designer`, `librarian`, `quick_task`) |
| `skills/<name>/SKILL.md` | Cross-repo capability packs (language dev/testing, coding-standards, api-design, repo-management, plus omp authoring skills) |
| `hooks/pre/safety-gate.ts` | Pre-tool hook: confirms/blocks destructive shell commands |

## Agent roster

The four custom agents (`coder`, `tester`, `security`, `docs`) are the only genuine gaps versus omp's bundled roster. The redundant copilot-ported agents (`Orchestrator`, `_Architect`, `_Planner`, `_Researcher`, `_Reviewer`) were removed: the main agent orchestrates and fans out natively, and the bundled `explore`/`plan`/`reviewer`/`oracle` cover research, planning, review and architecture. One-off specializations use the `task` tool's `role` field instead of a static agent file.

## Install target

The installer symlinks each entry into the live omp user directory `~/.omp/agent/` (it does **not** replace the directory, so `agent.db` and sessions stay machine-local):

```
~/.omp/agent/AGENTS.md  ->  <repo>/omp/AGENTS.md
~/.omp/agent/RULES.md   ->  <repo>/omp/RULES.md
~/.omp/agent/config.yml ->  <repo>/omp/config.yml
~/.omp/agent/agents     ->  <repo>/omp/agents
~/.omp/agent/skills     ->  <repo>/omp/skills
~/.omp/agent/hooks      ->  <repo>/omp/hooks
```

## Configuration

`config.yml` is symlinked like every other entry, so all machines share one settings file. Auth lives separately in `agent.db` (per-machine, never synced), so each machine signs in on its own.

Change a setting on any machine with `omp config set <key> <value>` (or `/settings`); the write lands in `omp/config.yml` through the symlink, so commit and `git pull` elsewhere to propagate. Notable non-default keys already set:

| Key | Value | Effect |
|-----|-------|--------|
| `read.defaultLimit` | `200` | smaller default read window |
| `tools.artifactSpillThreshold` | `30` | spill large tool output to artifacts sooner |
| `compaction.thresholdPercent` | `75` | compact context earlier |
| `memory.backend` | `mnemopi` | local SQLite memory plus `recall`/`retain`/`reflect` tools |
| `mnemopi.noEmbeddings` | `true` | FTS-only recall, network-free |
| `mnemopi.injectionTokenLimit` | `3000` | cap memory injected per session |
| `mnemopi.recallLimit` | `6` | max recalled memories per turn |

## Copilot hooks → omp equivalents

The copilot config used shell hooks; omp covers the same intent natively:

| Copilot hook | omp equivalent |
|--------------|----------------|
| `safety-gate.sh` (block dangerous commands) | `hooks/pre/safety-gate.ts` |
| `auto-format.sh` (format on edit) | `omp config set lsp.formatOnWrite true` |
| `auto-lint.sh` (lint on edit) | `lsp.diagnosticsOnWrite` (on by default) |
| `enforce-terse.sh` / workflow enforcement | `RULES.md` |
| `session-context.sh` (branch/project context) | Native project/environment prompt footer |

## Acknowledgments

Agent and skill content modeled on the `copilot/` config (itself based on Andy Hantke's [copilot-stuff](https://github.hpe.com/andy-hantke/copilot-stuff)).
