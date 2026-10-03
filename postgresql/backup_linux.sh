#!/bin/sh
set -eu
: "${CLINIQUE_DATABASE_URL:?Definir CLINIQUE_DATABASE_URL}"
OUT="${1:-clinique_mughulungu_$(date +%Y%m%d_%H%M%S).dump}"
pg_dump "$CLINIQUE_DATABASE_URL" --format=custom --file="$OUT"
echo "Sauvegarde PostgreSQL terminee: $OUT"
