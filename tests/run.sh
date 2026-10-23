#!/bin/sh
# Zero-dependency POSIX behavioral test suite for devtools-hub utilities.

set -eu

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

# --- 1. clean-ports.sh assertions ---
assert_fails sh ./scripts/clean-ports.sh
assert_fails sh ./scripts/clean-ports.sh "invalid_port"
assert_fails sh ./scripts/clean-ports.sh "8080a"
assert_succeeds sh ./scripts/clean-ports.sh 65534 --dry-run

# --- 2. xdg-audit.sh assertions ---
assert_fails sh ./scripts/xdg-audit.sh --invalid-flag
assert_succeeds sh ./scripts/xdg-audit.sh

# Isolated sandbox test for xdg-audit --strict failure on missing directories
SANDBOX="$(mktemp -d 2>/dev/null || mktemp -d -t devtools)"
trap 'rm -rf "$SANDBOX"' EXIT INT TERM HUP
assert_fails env XDG_CONFIG_HOME="$SANDBOX/missing" sh ./scripts/xdg-audit.sh --strict

# --- 3. sys-doctor.sh assertions ---
assert_succeeds sh ./scripts/sys-doctor.sh

# --- 4. with-lock.sh assertions ---
if [ -f ./scripts/with-lock.sh ]; then
    assert_fails sh ./scripts/with-lock.sh
    assert_fails sh ./scripts/with-lock.sh "../invalid_path" true
    assert_succeeds env XDG_STATE_HOME="$SANDBOX" sh ./scripts/with-lock.sh "ci-test" true
fi

printf "All %d behavioral assertions passed successfully.\n" "$PASS"
