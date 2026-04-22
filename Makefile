PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
BASH_COMPLETIONDIR ?= $(PREFIX)/share/bash-completion/completions
SCRIPT := och
COMPLETION := completions/och.bash
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
	bash -n $(SCRIPT)
	bash -n $(COMPLETION)

install:
	$(INSTALL) -Dm755 $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SCRIPT)
	$(INSTALL) -Dm644 $(COMPLETION) $(DESTDIR)$(BASH_COMPLETIONDIR)/$(SCRIPT)

install-user:
	$(MAKE) install PREFIX="$$HOME/.local"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(SCRIPT)
	rm -f $(DESTDIR)$(BASH_COMPLETIONDIR)/$(SCRIPT)
