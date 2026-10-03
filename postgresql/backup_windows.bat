@echo off
REM Sauvegarde PostgreSQL CLINIQUE MUGHULUNGU
REM Definir DATABASE_URL avant execution.
if "%CLINIQUE_DATABASE_URL%"=="" (
  echo CLINIQUE_DATABASE_URL n'est pas defini.
  exit /b 1
)
if "%1"=="" (
  echo Usage: backup_windows.bat chemin_sauvegarde.dump
  exit /b 1
)
pg_dump "%CLINIQUE_DATABASE_URL%" --format=custom --file="%1"
if errorlevel 1 exit /b 1
echo Sauvegarde PostgreSQL terminee.
