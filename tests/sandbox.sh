#!/bin/sh
# Isolated hermetic runtime test harness for devtools-hub.

set -eu

SANDBOX_ROOT="$(mktemp -d 2>/dev/null || mktemp -d -t 'devtools_sandbox')"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT INT TERM HUP

FAKE_BIN="$SANDBOX_ROOT/bin"
FAKE_HOME="$SANDBOX_ROOT/home"
mkdir -p "$FAKE_BIN" "$FAKE_HOME"

# Establish isolated environment variables
export HOME="$FAKE_HOME"
export XDG_CONFIG_HOME="$FAKE_HOME/.config"
export XDG_DATA_HOME="$FAKE_HOME/.local/share"
export XDG_STATE_HOME="$FAKE_HOME/.local/state"
export XDG_CACHE_HOME="$FAKE_HOME/.cache"
export PATH="$FAKE_BIN:$PATH"

printf "Running hermetic sandbox verification in %s...\n" "$SANDBOX_ROOT"

# Verify xdg-audit behavior when directories are auto-created
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"
sh ./scripts/xdg-audit.sh --strict >/dev/null

# Verify with-lock inside isolated state directory
sh ./scripts/with-lock.sh test-lock true >/dev/null

printf "Hermetic sandbox test passed with zero side-effects.\n"
