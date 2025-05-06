#!/bin/sh
set -e

CONFIG_DIR=/inspircd/conf
DEFAULTS_DIR=/defaults

mkdir -p "$CONFIG_DIR"

if [ -z "$(ls -A "$CONFIG_DIR")" ]; then
  echo "[InspIRCd Add-on] Initializing default config…"
  cp -r "$DEFAULTS_DIR/"* "$CONFIG_DIR/"
  chown -R inspircd:inspircd "$CONFIG_DIR"
fi

# 4) Run upstream entrypoint
exec /entrypoint.sh --runasroot "$@"