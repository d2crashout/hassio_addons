#!/usr/bin/env bash
set -e

# 1. Bootstrap your defaults into the persistent volume (only if empty)
if [ -z "$(ls -A /inspircd/conf)" ]; then
  echo "[InspIRCd Add‑on] Initializing default config…"
  cp -R /defaults/* /inspircd/conf/
fi

# 2. Delegate to the upstream entrypoint, carrying through any args
exec /entrypoint.sh "$@"