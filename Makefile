SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: xcresource

xctemplate: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: xcresource
	@install -d "$(bindir)"
	@install "$(BUILDDIR)/release/xcresource" "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/xcresource"
