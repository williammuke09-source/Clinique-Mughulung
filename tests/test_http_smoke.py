#!/usr/bin/env python3
"""HTTP smoke test using a temporary SQLite database."""
import os, tempfile, importlib.util, pathlib
tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False); tmp.close()
os.environ["CLINIQUE_DB_PATH"] = tmp.name
os.environ.pop("CLINIQUE_DATABASE_URL", None)
os.environ["CLINIQUE_SECRET_KEY"] = "test-secret"
spec = importlib.util.spec_from_file_location("cm_app", pathlib.Path(__file__).parents[1] / "clinique_mughulungu.py")
mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
client = mod.app.test_client()
r = client.get("/login"); assert r.status_code == 200, r.status_code
with client.session_transaction() as s: csrf = s.get("csrf")
r = client.post("/login", data={"username":"admin","password":"ChangeMe-Admin-2026!","_csrf":csrf}, follow_redirects=False)
assert r.status_code in (302,303), r.status_code
r = client.get("/dashboard"); assert r.status_code == 200, r.status_code
print("HTTP SMOKE TEST (SQLite): PASSED")
