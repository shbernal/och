PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
BASH_COMPLETIONDIR ?= $(PREFIX)/share/bash-completion/completions
SCRIPTS := och
COMPLETIONS := completions/och.bash
INSTALL := install

.PHONY: help test install install-user uninstall

help:
	@printf '%s\n' \
	  'Targets:' \
	  '  make test                      Syntax-check the script and completion' \
	  '  make install                   Install binary and bash completion' \
	  '  make install-user              Install to $$HOME/.local' \
	  '  make uninstall                 Remove installed binary and completion' \
	  '' \
	  'Variables:' \
	  '  PREFIX=/usr/local              Base install prefix' \
	  '  BINDIR=$(PREFIX)/bin           Install directory for the executable' \
	  '  BASH_COMPLETIONDIR=...         Install directory for bash completion' \
	  '  DESTDIR=...                    Optional packaging/staging prefix'

test:
	for script in $(SCRIPTS); do bash -n $$script; done
	for completion in $(COMPLETIONS); do bash -n $$completion; done

install:
	for script in $(SCRIPTS); do $(INSTALL) -Dm755 $$script $(DESTDIR)$(BINDIR)/$$script; done
	for completion in $(COMPLETIONS); do $(INSTALL) -Dm644 $$completion $(DESTDIR)$(BASH_COMPLETIONDIR)/$$(basename $$completion .bash); done

install-user:
	$(MAKE) install PREFIX="$$HOME/.local"

uninstall:
	for script in $(SCRIPTS); do rm -f $(DESTDIR)$(BINDIR)/$$script; done
	for completion in $(COMPLETIONS); do rm -f $(DESTDIR)$(BASH_COMPLETIONDIR)/$$(basename $$completion .bash); done
