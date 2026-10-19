# devtools-hub

A curated collection of lightweight, zero-dependency POSIX shell utilities and CLI automation scripts for systems engineers and DevOps workflows.

## Architecture & Design Philosophy

- **Zero External Dependencies**: Relies strictly on standard POSIX utilities (`sh`, `awk`, `sed`, `grep`, `lsof`) present across base Linux and macOS installations.
- **Deterministic Execution**: Built with strict error trapping (`set -eu`) and predictable exit codes for seamless integration into CI/CD pipelines and cron daemons.
- **Self-Contained Portability**: Each script in `scripts/` can be executed directly or copied into target hosts without requiring runtime package managers.

## Included Utilities

| Script | Description | Requirements |
| :--- | :--- | :--- |
| `scripts/port-cleaner.sh` | Identifies and gracefully terminates processes bound to specified local TCP ports (`SIGTERM` with fallback to `SIGKILL`). | `lsof` or `ss`, POSIX `sh` |

## Quick Usage

Clone the repository and execute utilities directly:

```sh
git clone [https://github.com/Abdelmalek2030/devtools-hub.git](https://github.com/Abdelmalek2030/devtools-hub.git)
cd devtools-hub
chmod +x scripts/*.sh

# Example: Reclaim local port 8080
./scripts/port-cleaner.sh 8080

