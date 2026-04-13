PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SCRIPT := och
INSTALL := install

.PHONY: help test install install-user uninstall

help:
	@printf '%s\n' \
	  'Targets:' \
	  '  make test                      Syntax-check the script' \
	  '  make install                   Install to $(DESTDIR)$(BINDIR)/och' \
	  '  make install-user              Install to $$HOME/.local/bin/och' \
	  '  make uninstall                 Remove $(DESTDIR)$(BINDIR)/och' \
	  '' \
	  'Variables:' \
	  '  PREFIX=/usr/local              Base install prefix' \
	  '  BINDIR=$(PREFIX)/bin           Install directory for the executable' \
	  '  DESTDIR=...                    Optional packaging/staging prefix'

test:
	bash -n $(SCRIPT)

install:
	$(INSTALL) -Dm755 $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SCRIPT)

install-user:
	$(MAKE) install PREFIX="$$HOME/.local"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(SCRIPT)
