#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f deploy_urls.json ]; then
  echo "No existe deploy_urls.json. Ejecute primero scripts/deploy.py."
  exit 1
fi

BACKEND=$(python3 -c "import json; print(json.load(open('deploy_urls.json'))['backend'])")
WEB=$(python3 -c "import json; print(json.load(open('deploy_urls.json')).get('web', ''))")

echo "Backend: $BACKEND"
curl -fsS "$BACKEND/health"
echo
curl -fsS -X POST "$BACKEND/api/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
echo
curl -fsS "$BACKEND/api/productos" > /dev/null
echo "API: lista de productos correcta"

if [ -n "$WEB" ]; then
  echo "Web: $WEB"
  curl -fsS "$WEB" > /dev/null
  echo "Web: respuesta correcta"
fi
