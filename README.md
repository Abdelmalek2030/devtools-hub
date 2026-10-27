# devtools-hub

<div align="center">

[![CI Matrix & Quality Gate](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/ci.yml/badge.svg)](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/ci.yml)
[![ShellCheck](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/shellcheck.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![POSIX Shell](https://img.shields.io/badge/Standard-POSIX%20sh-blue.svg)]()
[![XDG Base Directory](https://img.shields.io/badge/XDG-Compliant-green.svg)]()

**A curated, reference-grade suite of zero-dependency POSIX shell utilities, CLI productivity tooling, and system diagnostics engineered with XDG Base Directory specification compliance.**

</div>

---

## 🏗️ Architecture & Design Philosophy

`devtools-hub` is engineered for mission-critical UNIX environments adhering to strict *Zero Bloat & Portable Shell* principles:

- **Zero External Dependencies**: Relies exclusively on standard POSIX base utilities (`sh`, `awk`, `sed`, `grep`, `du`, `df`, `ps`, `mkdir`, `lsof`) natively available across base Unix installations.
- **XDG Base Directory Compliance**: Strictly adheres to `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, and `$XDG_STATE_HOME` without cluttering the user home directory.
- **Atomic Operations & Signal Safety**: Concurrency primitives utilize atomic kernel calls with deterministic signal-safe cleanup traps (`EXIT`, `INT`, `TERM`, `HUP`).
- **Strict Execution Boundaries**: Enforces strict variable parameter expansion (`set -eu`) with zero unquoted expansions.

---

## 🚀 Quick Installation (One-Line Bootstrap)

To install the complete utility suite and UNIX manual pages (`man1`) instantly on your UNIX/Linux/macOS node:

```sh
curl -sSL [https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh](https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh) | sudo bash
