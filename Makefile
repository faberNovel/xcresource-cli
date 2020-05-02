SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: xctemplate

xctemplate: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: xctemplate
	@install -d "$(bindir)"
	@install "$(BUILDDIR)/release/xctemplate" "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/xctemplate"
