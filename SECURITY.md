# Security Policy

## Supported Versions

Security updates and patches are applied directly to the `main` branch.

| Version | Supported          |
| ------- | ------------------ |
| `main`  | :white_check_mark: |

---

## Vulnerability Scope

Because `devtools-hub` utilities interact directly with local processes, file descriptors, and network sockets, we treat the following classes of issues as high-priority security vulnerabilities:
- Command injection via unsanitized environment variables or arguments.
- Insecure temporary file creation susceptible to symlink or race-condition attacks (`TOCTOU`).
- Unintended privilege escalation or unsafe file permission modifications.

---

## Reporting a Vulnerability

Please **do not** report security vulnerabilities through public GitHub issues.

Instead, send a detailed report to **Abdelmalek2030github@hotmail.com** including:
1. The affected script and specific execution path.
2. A minimal proof-of-concept reproducing the issue.
3. Suggested mitigation or patch (if available).

You will receive an initial acknowledgment within **48 hours** and a remediation timeline once the issue is triaged.
