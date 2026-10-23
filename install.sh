#!/bin/sh
# Secure, zero-dependency one-line installer for devtools-hub utilities.

set -eu

REPO="Abdelmalek2030/devtools-hub"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/main"
DEST_DIR="${PREFIX:-/usr/local}/bin"

printf "Installing devtools-hub utilities into %s...\n" "$DEST_DIR"

if [ ! -w "$DEST_DIR" ]; then
    printf "Error: Target directory '%s' is not writable. Run with sudo or set PREFIX.\n" "$DEST_DIR" >&2
    exit 1
fi

SCRIPTS="clean-ports.sh xdg-audit.sh sys-doctor.sh"

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

printf "\nInstallation complete. Utilities ready in %s.\n" "$DEST_DIR"
