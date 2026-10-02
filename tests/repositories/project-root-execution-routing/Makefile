SHELL := /bin/sh

DIR ?= components/game

.PHONY: help dev-install test verify

help:
	@printf '%s\n' \
	  'Project development interface:' \
	  '  make DIR=<target-directory> dev-install' \
	  '  make DIR=<target-directory> test' \
	  '  make DIR=<target-directory> verify'

dev-install:
	@sh scripts/public-command.sh install "$(DIR)"

test:
	@sh scripts/public-command.sh test "$(DIR)"

verify:
	@sh scripts/public-command.sh verify "$(DIR)"
