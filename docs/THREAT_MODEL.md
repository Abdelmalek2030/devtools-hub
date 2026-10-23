# Security Threat Model & Execution Invariants

This document defines the security boundaries, trust assumptions, and kernel-level mitigation strategies implemented across `devtools-hub` utilities.

---

## 1. Trust Boundaries & Attack Surface

| Boundary | Input Vector | Mitigation Strategy |
| :--- | :--- | :--- |
| **CLI Arguments** | Untrusted user/pipeline flags (`$1`, `$2`) | Strict POSIX pattern matching (`case`) rejecting non-numeric ports and path traversal tokens. |
| **Environment Variables** | `$XDG_*`, `$HOME`, `$PREFIX` | Safe parameter expansion with quoted variables (`"$VAR"`) to eliminate word splitting (`SC2086`) and glob injection. |
| **Process Table & Signals** | Output from `lsof(8)` and `ps(1)` | Line-oriented stream parsing (`IFS= read -r`) avoiding `eval` or unquoted subshell expansion. |

---

## 2. Vulnerability Class Mitigations

### Command Injection & Arbitrary Execution
- **Invariant**: Utilities never invoke `eval` or pass unvalidated strings to subshells.
- **Verification**: Enforced continuously via `shellcheck` static analysis in CI.

### TOCTOU (Time-of-Check to Time-of-Use) in Concurrency
- **Invariant**: File-based locking (`with-lock`) avoids non-atomic `[ -f lockfile ] && touch lockfile` patterns.
- **Mitigation**: Uses POSIX atomic directory creation (`mkdir`) which maps directly to the atomic kernel `mkdir(2)` syscall, paired with deterministic `trap` teardown on `EXIT`, `INT`, `TERM`, and `HUP`.

### Privilege Escalation Prevention
- **Invariant**: Scripts operate under principle of least privilege and never invoke `sudo` internally.
- **Mitigation**: Operations requiring elevated permissions fail gracefully with deterministic non-zero exit codes.
