# devtools-hub

A curated collection of lightweight, zero-dependency POSIX shell utilities and CLI automation scripts for systems engineers and DevOps workflows.

## Architecture & Design Philosophy

- **Zero External Dependencies**: Relies strictly on standard POSIX utilities (`sh`, `awk`, `sed`, `grep`, `du`, `df`, `ps`, `lsof`) present across base Linux and macOS installations.
- **XDG Base Directory Compliance**: Respects `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, and `$XDG_CACHE_HOME` conventions without polluting `$HOME`.
- **Deterministic Execution**: Built with strict error trapping (`set -eu`) and predictable exit codes. See [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) for execution pipeline specifications.

## Included Utilities

| Script | Description | Requirements |
| :--- | :--- | :--- |
| `scripts/clean-ports.sh` | Identifies and gracefully terminates processes bound to specified local TCP ports (`SIGTERM` with fallback to `SIGKILL`). | `lsof`, POSIX `sh` |
| `scripts/xdg-audit.sh` | Audits XDG Base Directory paths, fallback resolution, and directory disk usage with optional `--strict` CI verification. | `du`, `awk`, POSIX `sh` |
| `scripts/sys-doctor.sh` | Performs automated system health diagnostics covering kernel specs, load averages, disk pressure, and zombie processes. | `df`, `ps`, `awk`, POSIX `sh` |

## Quick Usage

Clone the repository and install or execute utilities directly:

```sh
git clone git@github.com:Abdelmalek2030/devtools-hub.git
cd devtools-hub

# Run system health diagnostics
./scripts/sys-doctor.sh

# Audit local XDG Base Directory compliance and disk usage
./scripts/xdg-audit.sh

# Inspect active PIDs on port 8080 without terminating (dry-run)
./scripts/clean-ports.sh 8080 --dry-run

# View UNIX manual pages
man ./man/clean-ports.1
man ./man/xdg-audit.1
man ./man/sys-doctor.1

# Optional: Install utilities and man pages globally to /usr/local
sudo make install
