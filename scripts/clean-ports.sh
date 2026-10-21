#!/bin/sh
# POSIX-compliant utility to inspect and terminate processes bound to a TCP port.

set -eu

usage() {
    printf "Usage: %s <port> [--kill]\n" "$(basename "$0")" >&2
    exit 1
}

[ "$#" -ge 1 ] || usage

PORT="$1"
ACTION="${2:-}"

case "$PORT" in
    ''|*[!0-9]*)
        printf "Error: Invalid port number '%s'.\n" "$PORT" >&2
        exit 1
        ;;
esac

PIDS="$(lsof -t -i :"$PORT" 2>/dev/null || true)"

if [ -z "$PIDS" ]; then
    printf "No active process found listening on port %s.\n" "$PORT"
    exit 0
fi

if [ "$ACTION" = "--kill" ]; then
    printf "%s\n" "$PIDS" | while IFS= read -r pid; do
        [ -n "$pid" ] || continue
        kill -15 "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null || true
        printf "Terminated process PID %s on port %s.\n" "$pid" "$PORT"
    done
else
    printf "Active PIDs on port %s:\n%s\n" "$PORT" "$PIDS"
fi

