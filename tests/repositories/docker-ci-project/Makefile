.PHONY: verify test

APP := docker compose run --rm app

# Canonical final verification: runs inside the managed app service.
verify:
	$(APP) npm test

# Convenience partial check (not the final gate).
test:
	$(APP) npm test
