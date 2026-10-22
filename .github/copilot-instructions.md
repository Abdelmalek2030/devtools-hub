# Engineering Guidelines for devtools-hub

This repository adheres to strict systems engineering principles. Any code additions, modifications, or reviews must follow these invariants:

1. **Strict POSIX sh Compliance**: Target `/bin/sh` exclusively. Avoid bashisms such as `[[ ]]`, arrays, `echo -e`, or process substitution.
2. **Static Analysis Enforcement**: Every utility script must pass `shellcheck` warnings-free and be verified via `sh -n`.
3. **Error Trapping & Determinism**: Scripts must enforce `set -eu`, quote parameter expansions to prevent word-splitting (SC2086), and handle cleanup safely via `trap`.
4. **XDG Base Directory Adherence**: Persistence paths must honor `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, and `$XDG_CACHE_HOME`.
