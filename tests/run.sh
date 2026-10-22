#!/bin/sh
# Zero-dependency POSIX behavioral test suite for devtools-hub utilities.

set -eu

SCRIPT="./scripts/clean-ports.sh"
PASS=0

assert_fails() {
    if "$@" >/dev/null 2>&1; then
        printf "FAIL: expected failure for '%s'\n" "$*" >&2
        exit 1
    fi
    PASS=$((PASS + 1))
}

assert_succeeds() {
    if ! "$@" >/dev/null 2>&1; then
        printf "FAIL: expected success for '%s'\n" "$*" >&2
        exit 1
    fi
    PASS=$((PASS + 1))
}

# 1. Missing arguments must exit non-zero
assert_fails sh "$SCRIPT"

# 2. Non-numeric port arguments must be rejected
assert_fails sh "$SCRIPT" "invalid_port"
assert_fails sh "$SCRIPT" "8080a"

# 3. High ephemeral unused port in dry-run mode must succeed cleanly
assert_succeeds sh "$SCRIPT" 65534 --dry-run

printf "All %d behavioral assertions passed.\n" "$PASS"
