PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
SCRIPTS_DIR := scripts
MAN_DIR := man

.PHONY: all help check lint test bench install uninstall

all: help

help:
	@printf "devtools-hub build & installation interface\n\n"
	@printf "Targets:\n"
	@printf "  make check      Verify POSIX sh syntax without executing scripts\n"
	@printf "  make lint       Run ShellCheck static analysis across all scripts\n"
	@printf "  make test       Execute zero-dependency POSIX behavioral test suite\n"
	@printf "  make bench      Run execution performance benchmark suite\n"
	@printf "  make install    Install utilities and man pages into $(PREFIX)\n"
	@printf "  make uninstall  Remove installed utilities and man pages\n"

check:
	@for f in $(SCRIPTS_DIR)/* tests/*.sh; do \
		if [ -f "$$f" ]; then sh -n "$$f"; fi; \
	done

lint: check
	@shellcheck $(SCRIPTS_DIR)/* tests/*.sh

test:
	@sh ./tests/run.sh

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
