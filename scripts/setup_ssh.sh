#!/usr/bin/env bash
set -euo pipefail

# Registra la clave SSH de fbrzz004 en GitHub y cambia el remoto a SSH.
# Requiere autorizar el permiso admin:public_key en el navegador.

CLAVE="$HOME/.ssh/ssh_for_fbrzz004.pub"

if [ ! -f "$CLAVE" ]; then
  echo "No existe $CLAVE"
  exit 1
fi

gh auth refresh -h github.com -s admin:public_key
gh ssh-key add "$CLAVE" --title "fbrzz004 $(hostname)"

cd "$(dirname "$0")/.."
git remote set-url origin git@github.com-fbrzz004:fbrzz004/lab10_techstore.git
ssh -T git@github.com-fbrzz004 || true
git push origin HEAD:main
