#!/usr/bin/env bash
set -euo pipefail
command -v docker >/dev/null || { echo "Docker requis."; exit 1; }
docker compose version >/dev/null || { echo "Docker Compose requis."; exit 1; }
test -f .env || { echo ".env manquant: copiez .env.production.example et renseignez les secrets."; exit 1; }
docker compose build
docker compose up -d postgres
for i in $(seq 1 30); do
  docker compose exec -T postgres pg_isready -U clinique -d clinique_mughulungu >/dev/null 2>&1 && break
  sleep 2
done
docker compose exec -T postgres pg_isready -U clinique -d clinique_mughulungu >/dev/null 2>&1 || { echo "PostgreSQL non prêt."; exit 1; }
docker compose up -d app
docker compose ps
echo "Application: http://localhost:8000/login"
