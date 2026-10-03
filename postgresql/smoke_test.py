#!/usr/bin/env python3
"""Real PostgreSQL smoke test. Requires a live PostgreSQL server."""
import os, sys
url = os.getenv("CLINIQUE_DATABASE_URL", "").strip()
if not url:
    print("ERROR: CLINIQUE_DATABASE_URL is not configured."); sys.exit(2)
try:
    import psycopg
except ImportError:
    print("ERROR: psycopg is not installed."); sys.exit(2)
required = {"users","roles","permissions","role_permissions","audit_logs",
"patients","patient_contacts","appointments","triage_records","consultations",
"medical_records","hospitalizations","hospitalization_observations","prescriptions",
"prescription_items","laboratory_requests","laboratory_results","medicines",
"medicine_categories","suppliers","stock_movements","inventory","invoices",
"payments","expenses","cash_transactions"}
with psycopg.connect(url) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")
        found = {r[0] for r in cur.fetchall()}
        missing = sorted(required - found)
        if missing:
            print("ERROR: missing tables:", ", ".join(missing)); sys.exit(1)
        cur.execute("SELECT COUNT(*) FROM roles"); roles = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM users"); users = cur.fetchone()[0]
print("POSTGRES SMOKE TEST: PASSED")
print(" - Required tables: OK")
print(f" - Roles: {roles}")
print(f" - Users: {users}")
