# Surfaces — disambiguation + per-surface context

NOT capability-specific. Per-capability `how` lives in `capability-matrix.md`. This file
defines each surface, how to disambiguate which one the user means, and surface-wide
context (access, navigation, limits). As of 2026-06-14.

## Disambiguation — which surface is the user in / asking about?
Never claim to "detect" your host. In priority order:
1. **User names it** → use that surface.
2. **Tool presence (heuristic, say so):** if you can call Bash / edit files / run code →
   almost certainly an agentic surface (Claude Code CLI/IDE or the web). If not → assume a
   hosted chat surface (claude.ai / Cowork / Chrome).
3. **Still ambiguous → answer for ALL surfaces** (per-surface mini-table). Correct everywhere.
4. Ask ONE question only if the surface materially changes the answer.

Spanish cues: "en el chat", "en la app", "en Claude Code", "en la terminal", "en la web",
"en Cowork", "en el navegador / Chrome". English cues mirror these.

## The five surfaces

### chat — Claude.ai (web, desktop app, mobile apps)
- The conversational product. Models picker, extended thinking, Artifacts, Projects, Research,
  web search, connectors, file creation, code execution (Python sandbox), Memory.
- Cannot touch your local filesystem or run your real terminal. Voice mode is mobile-only.
- Context ~200K (500K Enterprise on select models). Uploads: up to 500MB/file, 20 files/chat.
- Custom skills: upload a .zip (requires code execution). Skills do NOT sync to other surfaces.

### code — Claude Code (CLI + IDE extensions: VS Code, JetBrains, Desktop app)
- The agentic developer surface on YOUR machine. Edits files, runs commands, git, hooks,
  CLAUDE.md memory + auto memory, subagents (`Agent` tool), plan mode, worktrees, MCP
  (local+remote), plugins/marketplaces, statusline, output styles.
- Slash commands are real built-ins OR bundled skills (see availability.md "command notes").
- Scheduling: `/schedule` (alias `/routines`) creates cloud Routines. Browser automation via
  `--chrome` / `/chrome` with the Claude in Chrome extension.

### code-web — Claude Code on the web (cloud)
- Claude Code running on Anthropic-managed cloud at claude.ai/code. Clones a repo → edits in a
  sandbox → opens a PR. Keeps running with your laptop closed. Default branch prefix `claude/`.
- **Routines**: saved config (prompt + repos + connectors) run on a schedule / API call / GitHub
  event. Network access has FOUR levels: None / Trusted (default) / Full / Custom.
- No local filesystem, no local MCP servers. Research preview, paid plans.

### cowork — Claude Cowork (Claude Desktop app for macOS/Windows ONLY)
- Agentic task runner for knowledge work. Describe an outcome → it works and leaves the
  deliverable (Excel with formulas, PowerPoint, formatted documents). Reads/writes local files.
- Live Artifacts (persistent interactive HTML with history) and Cowork Projects.
- Scheduling is **LOCAL**: tasks run only while your computer is awake and the Desktop app is
  open — NOT cloud-autonomous (that's Routines). Mobile is only a messaging companion (beta).
- Paid plans (Pro/Max/Team/Enterprise). Not on web or mobile-as-worker.

### chrome — Claude in Chrome (browser extension, beta)
- Acts in your browser: click, type, navigate/manage tabs, read/extract page content, take
  screenshots, download files, fill forms. Uses your existing browser logins.
- Paid plans only (Pro/Max/Team/Enterprise). Pro is limited to Haiku 4.5; Max/Team/Enterprise
  can choose among the available models (verify versions — volatile).
- Integrates with Claude Code via `--chrome` / `/chrome` (ext v1.0.36+, Code v2.0.73+, direct
  Anthropic plan; not via Bedrock/Vertex/Foundry).

## Quick "where does X live" anchors
- Local files / terminal / git / hooks / CLAUDE.md / subagents / plan mode → **code** (web for PRs).
- Cloud scheduled coding (Routines) → **code-web** (createable from **code** via `/schedule`).
- Unattended office deliverables + local files, desktop → **cowork**.
- Artifacts / Projects / Research / voice (mobile) / easy uploads → **chat**.
- Browser automation → **chrome** (or **code** with `--chrome`).
- Connectors (Gmail/Calendar/Drive, MCP) → **chat / cowork / code / code-web** (admin-gated on orgs).
