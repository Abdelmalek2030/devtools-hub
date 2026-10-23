PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
SCRIPTS_DIR := scripts
MAN_DIR := man

.PHONY: all help check lint test bench sandbox install uninstall

all: help

help:
	@printf "devtools-hub build & installation interface\n\n"
	@printf "Targets:\n"
	@printf "  make check      Verify POSIX sh syntax across all scripts and tests\n"
	@printf "  make lint       Run ShellCheck static analysis\n"
	@printf "  make test       Execute zero-dependency behavioral test suite\n"
	@printf "  make sandbox    Run tests in an isolated hermetic sandbox\n"
	@printf "  make bench      Run performance latency benchmarks\n"
	@printf "  make install    Install utilities and man pages to $(PREFIX)\n"
	@printf "  make uninstall  Remove installed utilities and man pages\n"

check:
	@for f in $(SCRIPTS_DIR)/* tests/*.sh install.sh; do \
		if [ -f "$$f" ]; then sh -n "$$f"; fi; \
	done

lint: check
	@shellcheck $(SCRIPTS_DIR)/* tests/*.sh install.sh

test:
	@sh ./tests/run.sh

sandbox:
	@sh ./tests/sandbox.sh

bench:
	@sh ./tests/benchmark.sh

install:
	@mkdir -p "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MANDIR)"
	@for f in $(SCRIPTS_DIR)/*; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .sh); \
			install -m 0755 "$$f" "$(DESTDIR)$(BINDIR)/$$name"; \
		fi; \
	done
	@for m in $(MAN_DIR)/*.1; do \
		if [ -f "$$m" ]; then \
			install -m 0644 "$$m" "$(DESTDIR)$(MANDIR)/$$(basename "$$m")"; \
		fi; \
	done

uninstall:
	@for f in $(SCRIPTS_DIR)/*; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .sh); \
			rm -f "$(DESTDIR)$(BINDIR)/$$name"; \
		fi; \
	done
	@for m in $(MAN_DIR)/*.1; do \
		if [ -f "$$m" ]; then \
			rm -f "$(DESTDIR)$(MANDIR)/$$(basename "$$m")"; \
		fi; \
	done
