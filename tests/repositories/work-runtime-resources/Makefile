# Host entry points for the default runtime. Managed runtime (Node/npm,
# project commands) executes inside the app container; the host provides
# Git, Docker/Compose, and Make only.

.PHONY: verify test resource-check up down

verify:
	docker compose run --rm app npm run verify

test:
	docker compose run --rm app npm test

resource-check:
	docker compose run --rm app npm run resource-check

up:
	docker compose up -d app

down:
	docker compose down
