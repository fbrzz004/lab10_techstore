#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -d .git ]; then
  git init -b main
fi

gh auth setup-git >/dev/null 2>&1 || true

if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin https://github.com/fbrzz004/lab10_techstore.git
fi

git add -A
if ! git diff --cached --quiet; then
  git commit -m "${1:-Laboratorio 10: TechStore}"
fi

git push origin HEAD:main
