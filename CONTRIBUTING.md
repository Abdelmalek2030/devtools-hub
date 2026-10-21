# Contributing to devtools-hub

Contributions are welcome provided they strictly align with the core engineering principles of this repository: minimal surface area, zero bloat, and deterministic execution.

---

## 🛠️ Architectural Requirements

1. **Strict POSIX Compliance**: All utilities under `scripts/` must target standard `#!/bin/sh` and rely exclusively on base POSIX utilities (`awk`, `sed`, `grep`, `tr`, `find`, `lsof`). Bashisms (`[[ ]]`, arrays, ` pipefail`) are not permitted.
2. **XDG Base Directory Specification**: Scripts that persist state, cache, or configuration must respect `$XDG_CONFIG_HOME`, `$XDG_CACHE_HOME`, and `$XDG_STATE_HOME` with safe fallbacks.
3. **Safe Signal & Exit Handling**: Use `set -eu` where applicable, clean up temporary artifacts via `trap`, and return meaningful non-zero exit codes on failure.

---

## 🔍 Quality Gates

Before opening a Pull Request, verify your changes locally:

```sh
# Verify POSIX syntax and run ShellCheck static analysis
make lint
