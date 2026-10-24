#!/usr/bin/env bash
set -euo pipefail

BASE="http://127.0.0.1:5000"
TMP=$(mktemp)

resumen() {
  local metodo="$1" ruta="$2" datos="${3:-}"
  local codigo
  if [ -n "$datos" ]; then
    codigo=$(curl -s -o "$TMP" -w '%{http_code}' -X "$metodo" "$BASE$ruta" -H 'Content-Type: application/json' -d "$datos")
  else
    codigo=$(curl -s -o "$TMP" -w '%{http_code}' -X "$metodo" "$BASE$ruta")
  fi
  printf '%-6s %-42s HTTP %s\n' "$metodo" "$ruta" "$codigo"
}

printf '$ bash docs/pruebas_api_resumen.sh\n\n'

resumen GET /health
resumen POST /api/login '{"username":"admin","password":"admin123"}'
resumen POST /api/login '{"username":"admin","password":"0000"}'
resumen GET /api/productos
resumen GET '/api/productos/buscar?q=laptop'
resumen GET '/api/productos/buscar?q=xyz123'

curl -s -o "$TMP" -X POST "$BASE/api/productos" -H 'Content-Type: application/json' \
  -d '{"codigo":"PROD-999","nombre":"Producto de prueba","categoria":"Pruebas","precio":99.9,"stock":2}'
ID=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["id"])' "$TMP")
printf '%-6s %-42s HTTP 201  id=%s\n' POST /api/productos "$ID"

resumen PUT "/api/productos/$ID" '{"nombre":"Producto editado","categoria":"Pruebas","precio":109.9,"stock":5}'
resumen GET "/api/productos/$ID"
resumen DELETE "/api/productos/$ID"
