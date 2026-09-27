WORK ?=

.PHONY: help status verify recover-work reset-all

help:
	@printf '%s\n' \
	  'make status       WORK=<type>/<name>  observe Work runtime state (no changes)' \
	  'make verify       WORK=<type>/<name>  final Work runtime check' \
	  'make recover-work WORK=<type>/<name>  Work-scoped runtime recovery' \
	  'make reset-all                        remove ALL runtime state (broad, destructive)'

status:
	sh scripts/status.sh '$(WORK)'

verify:
	sh scripts/verify.sh '$(WORK)'

recover-work:
	sh scripts/recover-work.sh '$(WORK)'

reset-all:
	sh scripts/reset-all.sh
