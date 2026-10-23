#!/bin/sh
# Secure, zero-dependency one-line installer for devtools-hub utilities.

set -eu

REPO="Abdelmalek2030/devtools-hub"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/main"
PREFIX="${PREFIX:-/usr/local}"
DEST_DIR="${PREFIX}/bin"

printf "Installing devtools-hub utilities into %s...\n" "$DEST_DIR"

if [ ! -d "$DEST_DIR" ] && ! mkdir -p "$DEST_DIR" 2>/dev/null; then
    printf "Error: Cannot create directory '%s'. Re-run with sudo or define PREFIX.\n" "$DEST_DIR" >&2
    exit 1
fi

if [ ! -w "$DEST_DIR" ]; then
    printf "Error: Destination '%s' is not writable.\n" "$DEST_DIR" >&2
    exit 1
fi

SCRIPTS="clean-ports.sh xdg-audit.sh sys-doctor.sh with-lock.sh"

for script in $SCRIPTS; do
    name="$(basename "$script" .sh)"
    target="${DEST_DIR}/${name}"
    printf "Fetching %s -> %s\n" "$script" "$target"
    if command -v curl >/dev/null 2>&1; then
        curl -sSfL "${RAW_BASE}/scripts/${script}" -o "$target"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$target" "${RAW_BASE}/scripts/${script}"
    else
        printf "Error: Neither curl nor wget is available.\n" >&2
        exit 1
    fi
    chmod 0755 "$target"
done

printf "\nInstallation finished successfully. All utilities are active in %s.\n" "$DEST_DIR"
