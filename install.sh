#!/usr/bin/env bash
#
# claud — one-command installer for Claude Code.
# Installs the `claud` capability-router skill into ~/.claude/skills/claud.
#
# Usage:
#   ./install.sh                      # install (copy) into ~/.claude/skills/claud
#   curl -fsSL https://raw.githubusercontent.com/Hainrixz/claude-skill/main/install.sh | bash
#   CLAUD_LINK=1 ./install.sh         # symlink instead of copy (dev mode; from a local clone)
#   ./install.sh --uninstall          # remove the installed skill
#
set -euo pipefail

REPO_URL="https://github.com/Hainrixz/claude-skill.git"
SKILLS_DIR="$HOME/.claude/skills"
DEST="$SKILLS_DIR/claud"

# colors only when stdout is a terminal
if [ -t 1 ]; then
  BOLD=$'\033[1m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi
say()  { printf "%s\n" "$*"; }
ok()   { printf "%s✓%s %s\n" "$GREEN" "$RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$YELLOW" "$RESET" "$*"; }
die()  { printf "%s✗ %s%s\n" "$RED" "$*" "$RESET" >&2; exit 1; }

# --uninstall
if [ "${1:-}" = "--uninstall" ]; then
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then rm -rf "$DEST"; ok "Removed $DEST"; else warn "Nothing to remove at $DEST"; fi
  exit 0
fi

# Locate the skill source: prefer ./claud next to this script; otherwise clone the repo.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
CLEANUP_TMP=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/claud/SKILL.md" ]; then
  SRC="$SCRIPT_DIR/claud"
else
  command -v git >/dev/null 2>&1 || die "git is required (or run this from a cloned repo)."
  TMP="$(mktemp -d)"; CLEANUP_TMP="$TMP"
  say "Fetching claud from $REPO_URL ..."
  git clone --depth 1 --quiet "$REPO_URL" "$TMP/repo" || die "git clone failed."
  SRC="$TMP/repo/claud"
fi
[ -f "$SRC/SKILL.md" ] || die "Skill source (SKILL.md) not found at $SRC."

mkdir -p "$SKILLS_DIR"

# Back up any existing install
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  BAK="$DEST.bak-$(date +%Y%m%d%H%M%S)"
  mv "$DEST" "$BAK"
  warn "Existing install moved to $BAK"
fi

# Install (symlink only when sourcing from a kept-in-place local clone)
if [ "${CLAUD_LINK:-}" = "1" ] && [ -z "$CLEANUP_TMP" ]; then
  ln -s "$SRC" "$DEST"; ok "Symlinked $DEST -> $SRC"
else
  cp -R "$SRC" "$DEST"; ok "Installed skill to $DEST"
fi

[ -n "$CLEANUP_TMP" ] && rm -rf "$CLEANUP_TMP" || true

say ""
ok "${BOLD}claud installed for Claude Code.${RESET}"
say "  Try it:  ${BOLD}/claud${RESET}   (or just ask: \"can Claude edit local files?\" / \"¿puedo programar una tarea?\")"
say "  claude.ai / Cowork:  upload ${BOLD}dist/claud.zip${RESET} via Customize → Skills (paid plan, code execution on)."
