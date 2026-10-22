# devtools-hub

A curated collection of lightweight, zero-dependency POSIX shell utilities and CLI automation scripts for systems engineers and DevOps workflows.

## Architecture & Design Philosophy

- **Zero External Dependencies**: Relies strictly on standard POSIX utilities (`sh`, `awk`, `sed`, `grep`, `lsof`) present across base Linux and macOS installations.
- **Deterministic Execution**: Built with strict error trapping (`set -eu`) and predictable exit codes for seamless integration into CI/CD pipelines and cron daemons.
- **Self-Contained Portability**: Each script in `scripts/` can be executed directly or installed system-wide via `Makefile` without requiring runtime package managers.

## Included Utilities

| Script | Description | Requirements |
| :--- | :--- | :--- |
| `scripts/clean-ports.sh` | Identifies and gracefully terminates processes bound to specified local TCP ports (`SIGTERM` with fallback to `SIGKILL`). | `lsof`, POSIX `sh` |

## Quick Usage

Clone the repository and install or execute utilities directly:

```sh
git clone [https://github.com/Abdelmalek2030/devtools-hub.git](https://github.com/Abdelmalek2030/devtools-hub.git)
cd devtools-hub

# Inspect active PIDs on port 8080 without terminating (dry-run)
./scripts/clean-ports.sh 8080 --dry-run

# Reclaim local port 8080
./scripts/clean-ports.sh 8080

# Optional: Install utilities globally to /usr/local/bin
sudo make install
```

## Quality Gates

Verify POSIX syntax compliance and run static analysis locally:

```sh
make check
make lint
```

## License

Released under the [MIT License](./LICENSE).

