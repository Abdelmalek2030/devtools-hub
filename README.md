# devtools-hub

A curated, reference-grade suite of zero-dependency POSIX shell utilities, CLI productivity tooling, and systems diagnostics engineered for Linux, macOS, and BSD environments.

[![CI](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/ci.yml/badge.svg)](https://github.com/Abdelmalek2030/devtools-hub/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![POSIX Compliant](https://img.shields.io/badge/Standard-POSIX%20sh-brightgreen.svg)](#architecture--design-philosophy)
[![ShellCheck Verified](https://img.shields.io/badge/Linter-ShellCheck%20Passing-success.svg)](#quality-gates--testing)

---

## Architecture & Design Philosophy

- **Zero External Dependencies**: Relies exclusively on standard POSIX base utilities (`sh`, `awk`, `sed`, `grep`, `du`, `df`, `ps`, `mkdir`, `lsof`) natively available across base Unix installations.
- **XDG Base Directory Compliance**: Strictly adheres to `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, and `$XDG_CACHE_HOME` without cluttering `$HOME`.
- **Atomic Operations & Signal Safety**: Concurrency primitives utilize atomic kernel calls (`mkdir(2)`) with deterministic signal-safe cleanup traps (`EXIT`, `INT`, `TERM`, `HUP`).
- **Hermetic & Deterministic**: Enforces `set -eu`, strict variable parameter expansion (zero unquoted expansions), and unambiguous exit codes.
- **Formal Specifications**:
  - [Architecture & Execution Pipeline Specification](docs/ARCHITECTURE.md)
  - [Security Threat Model & Kernel Safety Invariants](docs/THREAT_MODEL.md)

---

## Core Utilities Matrix

| Script | Command | Description | Manual Page | Requirements |
| :--- | :--- | :--- | :--- | :--- |
| `scripts/clean-ports.sh` | `clean-ports` | Identifies and gracefully terminates processes bound to specified local TCP ports (`SIGTERM` with fallback to `SIGKILL`). Supports `--dry-run`. | `man ./man/clean-ports.1` | `lsof`, POSIX `sh` |
| `scripts/xdg-audit.sh` | `xdg-audit` | Audits XDG directory compliance, evaluates fallback paths, and measures storage footprint. Supports `--strict` assertion mode for CI. | `man ./man/xdg-audit.1` | `du`, `awk`, POSIX `sh` |
| `scripts/sys-doctor.sh` | `sys-doctor` | Comprehensive system health audit covering kernel architecture, load averages, root disk pressure thresholds, and zombie processes. | `man ./man/sys-doctor.1` | `df`, `ps`, `awk`, POSIX `sh` |
| `scripts/with-lock.sh` | `with-lock` | Atomic directory mutex wrapper that prevents overlapping cron jobs, background daemons, or concurrent CI/CD pipeline runs. | `man ./man/with-lock.1` | `mkdir`, POSIX `sh` |

---

## Installation

### Method 1: Standalone One-Line Bootstrap (Recommended)

Install utilities directly without cloning the repository:

```sh
curl -sSfL [https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh](https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh) | sh
```

To install into a custom prefix (e.g., `~/.local`):

```sh
curl -sSfL [https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh](https://raw.githubusercontent.com/Abdelmalek2030/devtools-hub/main/install.sh) | PREFIX="$HOME/.local" sh
```

### Method 2: Build & Install via Makefile

Clone the repository and install utilities along with their section 1 UNIX manual pages:

```sh
git clone git@github.com:Abdelmalek2030/devtools-hub.git
cd devtools-hub

# System-wide installation into /usr/local
sudo make install

# Or unprivileged installation into ~/.local
make PREFIX="$HOME/.local" install
```

---

## Operational Usage

### 1. Port Reclaiming (`clean-ports`)
```sh
# Inspect active processes on TCP port 8080 without terminating
clean-ports 8080 --dry-run

# Gracefully terminate processes holding TCP port 3000
clean-ports 3000
```

### 2. XDG Compliance Auditing (`xdg-audit`)
```sh
# Inspect current XDG directory paths and disk usage
xdg-audit

# Enforce strict compliance (fails with exit code 1 if any XDG directory is missing)
xdg-audit --strict
```

### 3. System Diagnostic Health Check (`sys-doctor`)
```sh
# Run instant environment health inspection
sys-doctor
```

### 4. Atomic Concurrency Locking (`with-lock`)
```sh
# Ensure backup or deployment tasks never execute concurrently
with-lock nightly-backup /usr/local/bin/backup-task.sh
```

---

## Shell Completions

Programmable tab-completions are provided for both Bash and Zsh:

- **Bash**: Source `completions/clean-ports.bash` or copy to `/etc/bash_completion.d/`
- **Zsh**: Add `completions/_clean-ports` to your `$fpath`

---

## Quality Gates & Verification

The repository enforces end-to-end quality validation across POSIX syntax, static analysis, hermetic sandboxing, and execution latency benchmarking:

```sh
# 1. Verify POSIX /bin/sh syntax compliance
make check

# 2. Run ShellCheck static analysis with aggressive rules
make lint

# 3. Execute zero-dependency behavioral test suite
make test

# 4. Run tests inside an isolated disposable filesystem sandbox
make sandbox

# 5. Measure execution latency across all utilities
make bench
```

---

## Security & Governance

- [Security Policy & Vulnerability Disclosure](SECURITY.md)
- [Code Owners & Review Gates](.github/CODEOWNERS)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Changelog History](CHANGELOG.md)

---

## License

Released under the [MIT License](LICENSE). Engineered with zero external runtime dependencies by [Abdelmalek](https://github.com/Abdelmalek2030).
