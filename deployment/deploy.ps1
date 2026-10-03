$ErrorActionPreference = "Stop"
docker --version | Out-Null
docker compose version | Out-Null
if (-not (Test-Path ".env")) { throw ".env manquant: copiez .env.production.example et renseignez les secrets." }
docker compose build
docker compose up -d postgres
for ($i=0; $i -lt 30; $i++) {
  docker compose exec -T postgres pg_isready -U clinique -d clinique_mughulungu
  if ($LASTEXITCODE -eq 0) { break }
  Start-Sleep -Seconds 2
}
docker compose up -d app
docker compose ps
Write-Host "Application: http://localhost:8000/login"
