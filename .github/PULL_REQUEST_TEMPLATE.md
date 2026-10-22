## Summary

Briefly describe the architectural reason for this change and the problem it solves.

## Quality Gate Checklist

- [ ] **Zero Dependencies**: Relies strictly on standard POSIX utilities.
- [ ] **Syntax & Static Analysis**: Passed `make check` and `make lint` with zero warnings.
- [ ] **Behavioral Assertions**: Passed `make test` (`sh ./tests/run.sh`).
- [ ] **Documentation**: Updated `man/` manual pages and `README.md` if CLI flags changed.
