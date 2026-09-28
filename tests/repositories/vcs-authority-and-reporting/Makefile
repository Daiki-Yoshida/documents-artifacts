.PHONY: test verify external-check

test:
	npm test

verify: test
	bash scripts/authority-check.sh

external-check:
	bash scripts/external-check.sh
