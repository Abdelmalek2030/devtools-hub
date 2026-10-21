PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SCRIPTS_DIR := scripts

.PHONY: all help lint check install uninstall

all: help

help:
	@printf "devtools-hub build & installation interface\n\n"
	@printf "Targets:\n"
	@printf "  make lint       Run ShellCheck static analysis across all scripts\n"
	@printf "  make check      Verify POSIX sh syntax without executing scripts\n"
	@printf "  make install    Install executable utilities into $(BINDIR)\n"
	@printf "  make uninstall  Remove installed utilities from $(BINDIR)\n"

check:
	@for f in $(SCRIPTS_DIR)/*; do \
		if [ -f "$$f" ]; then sh -n "$$f"; fi; \
	done

lint: check
	@shellcheck $(SCRIPTS_DIR)/*

install:
	@mkdir -p "$(DESTDIR)$(BINDIR)"
	@for f in $(SCRIPTS_DIR)/*; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .sh); \
			install -m 0755 "$$f" "$(DESTDIR)$(BINDIR)/$$name"; \
		fi; \
	done

uninstall:
	@for f in $(SCRIPTS_DIR)/*; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .sh); \
			rm -f "$(DESTDIR)$(BINDIR)/$$name"; \
		fi; \
	done
