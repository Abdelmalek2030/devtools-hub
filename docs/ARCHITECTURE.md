# Architecture & Execution Specification

This document outlines the internal execution pipeline, signal lifecycle, and POSIX portability invariants of `devtools-hub`.

---

## 1. Execution Pipeline (`clean-ports`)

```text
[CLI Input: <port> [--dry-run]]
       │
       ▼
┌──────────────────────────────┐
│ 1. Argument Sanitization     │ ──(Invalid / Non-numeric)──► [Exit 1: stderr]
└──────────────┬───────────────┘
               │ (Valid TCP Port)
               ▼
┌──────────────────────────────┐
│ 2. Socket Lookup (lsof -t)   │ ──(No Active Socket)───────► [Exit 0: Free]
└──────────────┬───────────────┘
               │ (Resolved PID List)
               ▼
┌──────────────────────────────┐
│ 3. Execution Mode Router     │ ──(--dry-run)──────────────► [Exit 0: Print PIDs]
└──────────────┬───────────────┘
               │ (Default Reclaim Mode)
               ▼
┌──────────────────────────────┐
│ 4. Signal Dispatch Loop      │ ──► kill -15 (SIGTERM) ──(Fallback)──► kill -9 (SIGKILL)
└──────────────┬───────────────┘
               │
               ▼
       [Exit 0: Reclaimed]
