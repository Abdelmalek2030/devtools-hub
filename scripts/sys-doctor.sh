#!/bin/sh
# POSIX-compliant system diagnostic utility for environment health checks.

set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    status="$1"
    msg="$2"
    if [ "$status" = "OK" ]; then
        printf "[${GREEN}OK${NC}] %s\n" "$msg"
    elif [ "$status" = "WARN" ]; then
        printf "[${YELLOW}WARN${NC}] %s\n" "$msg"
    else
        printf "[${RED}FAIL${NC}] %s\n" "$msg"
    fi
}

printf "=== System Doctor Diagnostic Suite ===\n\n"

# 1. Check Operating System Kernel
KERNEL="$(uname -s 2>/dev/null || printf "Unknown")"
ARCH="$(uname -m 2>/dev/null || printf "Unknown")"
print_status "OK" "Kernel architecture: $KERNEL ($ARCH)"

# 2. Check Load Average (Linux / macOS compatible)
if [ -f /proc/loadavg ]; then
    LOAD="$(awk '{print $1, $2, $3}' /proc/loadavg)"
    print_status "OK" "CPU Load Average (1m, 5m, 15m): $LOAD"
elif command -v uptime >/dev/null 2>&1; then
    LOAD="$(uptime)"
    print_status "OK" "System Uptime & Load: $LOAD"
else
    print_status "WARN" "Unable to determine system load average."
fi

# 3. Check Root Partition Disk Space
DISK_USAGE="$(df -h / | awk 'NR==2 {print $5}' | tr -d '%' || printf "0")"
if [ "$DISK_USAGE" -gt 90 ] 2>/dev/null; then
    print_status "FAIL" "Root partition usage is critical: ${DISK_USAGE}%"
    EXIT_CODE=1
else
    print_status "OK" "Root partition usage is healthy: ${DISK_USAGE}%"
    EXIT_CODE=0
fi

# 4. Check Zombie Processes
if command -v ps >/dev/null 2>&1; then
    ZOMBIES="$(ps -ef 2>/dev/null | awk '$8=="Z" {print $2}' | wc -l | tr -d ' ' || printf "0")"
    if [ "$ZOMBIES" -gt 0 ]; then
        print_status "WARN" "Detected $ZOMBIES zombie process(es)."
    else
        print_status "OK" "No zombie processes detected."
    fi
fi

printf "\nDiagnostic completed successfully.\n"
exit "${EXIT_CODE:-0}"
