#!/usr/bin/env bash
set -euo pipefail

BASE="${BASE_URL:-http://127.0.0.1:5000}"

peticion() {
  local metodo="$1"
  local ruta="$2"
  local datos="${3:-}"

  printf '\n%s %s\n' "$metodo" "$ruta"
  if [ -n "$datos" ]; then
    curl -s -w '\nHTTP %{http_code}\n' -X "$metodo" "$BASE$ruta" \
      -H 'Content-Type: application/json' -d "$datos"
  else
    curl -s -w '\nHTTP %{http_code}\n' -X "$metodo" "$BASE$ruta"
  fi
}

peticion GET /health
peticion POST /api/login '{"username":"admin","password":"admin123"}'
peticion POST /api/login '{"username":"admin","password":"0000"}'
peticion GET /api/productos > /dev/null
peticion GET '/api/productos/buscar?q=laptop'
peticion GET '/api/productos/buscar?q=xyz123'

RESPUESTA=$(curl -s -X POST "$BASE/api/productos" \
  -H 'Content-Type: application/json' \
  -d '{"codigo":"PROD-999","nombre":"Producto de prueba","categoria":"Pruebas","precio":99.9,"stock":2,"descripcion":"Producto temporal"}')
printf '\nPOST /api/productos\n%s\n' "$RESPUESTA"
ID=$(printf '%s' "$RESPUESTA" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')

peticion PUT "/api/productos/$ID" \
  '{"nombre":"Producto de prueba editado","categoria":"Pruebas","precio":109.9,"stock":5,"descripcion":"Producto temporal editado"}'
peticion GET "/api/productos/$ID"
peticion DELETE "/api/productos/$ID"
