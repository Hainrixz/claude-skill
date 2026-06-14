# Availability — plan gating + cross-surface exclusives

**VOLATILE data.** Plans, limits, and exclusives change often. State answers "as of
2026-06-14" and verify against `sources.md` URLs when web tools are available.

## Plan gating (corrected, verified)
- **Web search**: ALL plans incl. Free (not Free-excluded). Team/Enterprise: an Owner enables
  it in Admin → Capabilities first.
- **Projects**: ALL plans incl. Free (Free cap = **5 projects**). Only the enhanced project
  knowledge (RAG ~10x auto-scaling) is paid-only.
- **Memory (cross-chat)**: ALL plans incl. Free.
- **Chat search** (Claude referencing past conversations): **paid-only** (Pro/Max/Team/Enterprise).
  (Different gating from Memory — do not lump them together.)
- **Research**: **paid-only** (Pro/Max/Team/Enterprise); requires web search enabled. Duration:
  official wording is "thorough answers in minutes" — do NOT assert a fixed minute count.
- **Extended thinking**: toggle is NOT plan-gated; effort levels just consume your plan limits.
- **File creation + code execution** (xlsx/pptx/docx/pdf, Python): ALL plans (Settings →
  Capabilities; Enterprise on by org default). Files up to 30MB.
- **Voice mode**: ALL plans, **mobile apps (iOS/Android) only** (beta). Enterprise admins can disable.
- **Artifacts**: create + discover on all plans. Persistent storage + API/MCP-backed apps:
  Pro/Max/Team/Enterprise.
- **Connectors (incl. Google Workspace)**: available to all on Claude/Cowork/Desktop/Mobile + API.
  Gate is administrative: Team/Enterprise Owner must enable before members authenticate. Not a
  Free/Pro tier capability gate.
- **Cowork**: paid plans (Pro/Max/Team/Enterprise); Claude Desktop (macOS/Windows) only.
- **Claude Code on the web + Routines**: research preview, paid plans (Pro/Max/Team; Enterprise
  with premium seats).
- **Claude in Chrome**: beta, paid plans only. Pro = Haiku 4.5; Max/Team/Enterprise choose among
  available models (versions volatile).
- **Context window**: ~200K standard; 500K Enterprise on select models; up to 1M on select
  models/platforms.
- **Compliance API, advanced retention, 500K context**: Enterprise.

## Capability boundaries that surprise people
- **Send email → NO** on every surface. The Gmail connector only creates DRAFTS; you press Send.
  (Calendar, by contrast, supports create/update/delete.)
- **Generate images/video/audio → not native.** Only via a connector/MCP or as SVG/HTML/code.
  Confidence volatile; verify in docs.
- **Voice mode → mobile only**, not desktop/web.
- **Cowork scheduling → local**, only while the Desktop app is open. Not cloud-autonomous.
- **Custom skills → portable format, NOT synced.** Uploading to claude.ai ≠ available on the API
  ≠ in Claude Code's filesystem. Deploy per surface.

## Exclusive to one surface (or a pair)
- **Claude Code only**: hooks, CLAUDE.md memory hierarchy + auto memory, git worktrees,
  statusline customization, output styles, plugins/marketplaces, the local MCP servers.
- **Claude Code + Claude Code on the web**: editing a real codebase, running commands,
  plan mode, opening PRs, subagents, Routines.
- **Claude Code on the web only**: cloud-autonomous Routines (createable from the CLI via
  `/schedule`); 4-level network sandbox.
- **Cowork only**: unattended office deliverables on the desktop, Live Artifacts, Cowork Projects.
- **Chat only**: Artifacts panel + publish, Research, chat Projects, Memory/chat-search, mobile
  voice mode, easy drag-and-drop uploads.
- **Chrome only**: live browser automation using your logged-in sessions (also reachable from
  Claude Code via `--chrome`).

## Command notes (Claude Code) — accuracy guardrails
- **Do NOT exist** (do not suggest): `/output-style` (removed; use `/config` → Output style),
  `/vim` (removed; use `/config` → Editor mode), `/commit` & `/pr` (come from the
  `commit-commands` plugin, not built-in), `/remote` (it's `/remote-control`, alias `/rc`),
  `/agent-teams` (no command; experimental, env `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`),
  `/project` (does not exist), `/skill` (it's `/skills`, plural).
- **Aliases, not primary**: `/bug` → `/feedback`; `/cost` → `/usage`.
- **Bundled skills (not hardcoded built-ins)**: `/code-review`, `/batch`, `/loop`, `/run`,
  `/verify`. `/ultrareview` works but prefer `/code-review ultra`. `/run` & `/verify` need v2.1.145+.
- **Version-gated**: `/cd` (v2.1.169+), auto memory (v2.1.59+).
- **Subagent tool name is `Agent`** (not "Task").
- **`disable-model-invocation`** is a real Claude Code frontmatter field, BUT the local
  skill-creator `quick_validate.py` rejects it and `package_skill.py` won't package a skill that
  uses it. This skill deliberately does not use it.
