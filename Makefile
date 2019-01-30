# stest
# See LICENSE file for copyright and license details.

PREFIX ?= $(shell [ -d /usr/bin ] && echo /usr || echo)
MANPREFIX ?= $(shell [ -d /usr/share/man ] && echo /usr/share/man || echo ${PREFIX}/man)


SRC = stest.c
OBJ = $(SRC:.c=.o)

all: options stest

options:
	@echo stest build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu stest $(OBJ) dmenu-$(VERSION).tar.gz

dist: clean
	mkdir -p stest-$(VERSION)
	cp LICENSE Makefile README arg.h \
		stest.1 $(SRC)\
		stest-$(VERSION)
	tar -cf stest-$(VERSION).tar stest-$(VERSION)
	gzip stest-$(VERSION).tar
	rm -rf stest-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
