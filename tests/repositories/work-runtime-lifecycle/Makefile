# Host entry points. Managed runtime (Node/npm, project commands)
# executes inside the app container; the host provides Git,
# Docker/Compose, and Make only.

.PHONY: verify test resource-check lifecycle-check up down \
	require-work work-up work-status work-config work-verify \
	work-down work-cleanup

verify:
	docker compose run --rm app npm run verify
	sh scripts/lifecycle-check.sh

test:
	docker compose run --rm app npm test

resource-check:
	docker compose run --rm app npm run resource-check

lifecycle-check:
	sh scripts/lifecycle-check.sh

up:
	docker compose up -d app

down:
	docker compose down

# --- Parallel Work runtime ----------------------------------------------
# Usage: make work-up WORK=feat/schema-preview  (confirmed Work identity)
#
# Work-scoped resource identities derive deterministically from
# project + confirmed Work identity + role, matching
# scripts/resource-identity.js (same slug/cksum derivation in POSIX tools):
#   compose project / db volume / network  →  wrr-<work-slug>[-role]
#   host port                               →  8100 + cksum(work) % 900
# The toolchain image and package cache are project-scoped and shared.

WORK ?=
WORK_SLUG := $(shell printf '%s' '$(WORK)' | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9][^a-z0-9]*/-/g' -e 's/^-//' -e 's/-$$//')
WORK_PROJECT := wrr-$(WORK_SLUG)
WORK_PORT := $(shell printf '%s' '$(WORK)' | cksum | awk '{print 8100 + ($$1 % 900)}')
WORK_ENV = DB_VOLUME_NAME=$(WORK_PROJECT)-db-data RUNTIME_NETWORK_NAME=$(WORK_PROJECT)-net APP_HOST_PORT=$(WORK_PORT)

require-work:
	@test -n "$(WORK)" || { \
		echo 'make: WORK=<confirmed-work-identity> is required, e.g. make work-up WORK=feat/schema-preview'; \
		exit 2; \
	}
	@test -n "$(WORK_SLUG)" || { echo "make: WORK '$(WORK)' has no usable slug"; exit 2; }

work-up: require-work
	$(WORK_ENV) docker compose -p $(WORK_PROJECT) up -d app

work-status: require-work
	$(WORK_ENV) docker compose -p $(WORK_PROJECT) ps

work-config: require-work
	$(WORK_ENV) docker compose -p $(WORK_PROJECT) config

work-verify: require-work
	$(WORK_ENV) docker compose -p $(WORK_PROJECT) run --rm app npm run verify

work-down: require-work
	docker compose -p $(WORK_PROJECT) down

# Scoped cleanup: tears down the Work runtime including its Work-scoped
# data volume.
work-cleanup: require-work
	docker compose -p $(WORK_PROJECT) down -v
