from pathlib import Path
import ast

p = Path(__file__).parents[1] / "clinique_mughulungu.py"
src = p.read_text(encoding="utf-8")
ast.parse(src)

required = [
    "CLINIQUE_DATABASE_URL",
    "psycopg",
    "role_permissions",
    "audit_logs",
    "patients",
    "consultations",
    "hospitalizations",
    "medicines",
    "stock_movements",
    "inventory",
    "invoices",
    "payments",
    "expenses",
    "cash_transactions",
    "laboratory_requests",
    "laboratory_results",
]
missing = [x for x in required if x not in src]
if missing:
    raise SystemExit("MISSING: " + ", ".join(missing))
print("SOURCE_TEST=PASS")
