#!/usr/bin/env bash
set -euo pipefail
docker compose exec -T app python postgresql/smoke_test.py
docker compose exec -T app python tests/test_http_smoke.py
docker compose logs --tail=100 app
docker compose logs --tail=100 postgres
echo "Validation technique terminée."
