#!/bin/sh
# POSIX-compliant atomic mutex wrapper using mkdir(2) for cron and CI concurrency control.

set -eu

usage() {
    printf "Usage: %s <lock-name> <command> [args...]\n" "$(basename "$0")" >&2
    exit 1
}

[ "$#" -ge 2 ] || usage

LOCK_NAME="$1"
shift

case "$LOCK_NAME" in
    ''|*[!a-zA-Z0-9._-]*)
        printf "Error: Invalid lock identifier '%s'. Use alphanumeric, '.', '_', or '-'.\n" "$LOCK_NAME" >&2
        exit 1
        ;;
esac

RUNTIME_DIR="${XDG_STATE_HOME:-${TMPDIR:-/tmp}}"
mkdir -p "$RUNTIME_DIR" 2>/dev/null || true
LOCK_DIR="${RUNTIME_DIR}/devtools-hub.${LOCK_NAME}.lock"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    printf "Error: Lock '%s' is currently held by another active process.\n" "$LOCK_NAME" >&2
    exit 1
fi

cleanup() {
    rmdir "$LOCK_DIR" 2>/dev/null || true
}

trap cleanup EXIT INT TERM HUP

"$@"
