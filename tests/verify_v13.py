#!/usr/bin/env python3
"""Static verification for CLINIQUE MUGHULUNGU V1.3.

This script checks source/package consistency only. It does not require Flask
or a running PostgreSQL server and therefore does not claim runtime success.
"""
from pathlib import Path
import ast
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "clinique_mughulungu.py"
SCHEMA = ROOT / "postgresql" / "schema.sql"

errors = []

def need(path, label):
    if not path.exists():
        errors.append(f"Missing {label}: {path}")

need(APP, "application source")
need(SCHEMA, "PostgreSQL schema")

if APP.exists():
    source = APP.read_text(encoding="utf-8")
    try:
        ast.parse(source)
    except SyntaxError as exc:
        errors.append(f"Python syntax error: {exc}")

    for token in [
        "CLINIQUE_DATABASE_URL",
        "psycopg",
        "dict_row",
        "INSERT OR IGNORE",
        "ON CONFLICT DO NOTHING",
        "pg_dump",
    ]:
        if token not in source:
            errors.append(f"Expected PostgreSQL/security token absent from app: {token}")

if SCHEMA.exists():
    s = SCHEMA.read_text(encoding="utf-8").lower()
    required = [
        "create table users",
        "create table roles",
        "create table permissions",
        "create table audit_logs",
        "create table patients",
        "create table patient_contacts",
        "create table appointments",
        "create table triage_records",
        "create table consultations",
        "create table medical_records",
        "create table hospitalizations",
        "create table hospitalization_observations",
        "create table prescriptions",
        "create table prescription_items",
        "create table laboratory_requests",
        "create table laboratory_results",
        "create table medicines",
        "create table medicine_categories",
        "create table suppliers",
        "create table stock_movements",
        "create table inventory",
        "create table invoices",
        "create table payments",
        "create table expenses",
        "create table cash_transactions",
    ]
    for token in required:
        if token not in s:
            errors.append(f"Required table not found in PostgreSQL schema: {token}")

if errors:
    print("STATIC VERIFICATION: FAILED")
    for e in errors:
        print(" -", e)
    sys.exit(1)

print("STATIC VERIFICATION: PASSED")
print(" - Python AST syntax: OK")
print(" - PostgreSQL adapter/configuration markers: OK")
print(" - Required cahier-des-charges tables present: OK")
print(" - This is NOT a live PostgreSQL/HTTP runtime test.")
