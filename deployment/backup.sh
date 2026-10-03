#!/usr/bin/env bash
set -euo pipefail
mkdir -p backups
STAMP="$(date +%Y%m%d_%H%M%S)"
docker compose exec -T postgres pg_dump -U clinique -d clinique_mughulungu --format=custom > "backups/clinique_mughulungu_${STAMP}.dump"
echo "Sauvegarde créée."
