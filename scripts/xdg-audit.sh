#!/bin/sh
# POSIX-compliant utility to audit XDG Base Directory paths and disk usage.

set -eu

usage() {
    printf "Usage: %s [--strict]\n" "$(basename "$0")" >&2
    exit 1
}

STRICT=0
if [ "$#" -gt 1 ]; then
    usage
elif [ "$#" -eq 1 ]; then
    case "$1" in
        --strict) STRICT=1 ;;
        *) usage ;;
    esac
fi

HOME_DIR="${HOME:-/tmp}"
XDG_CONFIG="${XDG_CONFIG_HOME:-$HOME_DIR/.config}"
XDG_DATA="${XDG_DATA_HOME:-$HOME_DIR/.local/share}"
XDG_STATE="${XDG_STATE_HOME:-$HOME_DIR/.local/state}"
XDG_CACHE="${XDG_CACHE_HOME:-$HOME_DIR/.cache}"

FAIL=0

audit_dir() {
    label="$1"
    target="$2"
    if [ -d "$target" ]; then
        size="$(du -sh "$target" 2>/dev/null | awk '{print $1}' || printf "unknown")"
        printf "[OK]      %-16s %s (%s)\n" "$label" "$target" "$size"
    else
        printf "[MISSING] %-16s %s\n" "$label" "$target"
        if [ "$STRICT" -eq 1 ]; then
            FAIL=1
        fi
    fi
}

audit_dir "XDG_CONFIG_HOME" "$XDG_CONFIG"
audit_dir "XDG_DATA_HOME"   "$XDG_DATA"
audit_dir "XDG_STATE_HOME"  "$XDG_STATE"
audit_dir "XDG_CACHE_HOME"  "$XDG_CACHE"

exit "$FAIL"
