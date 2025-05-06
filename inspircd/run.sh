#!/bin/sh
set -e

CONFIG_DIR=/inspircd/conf
DEFAULTS_DIR=/defaults

mkdir -p "$CONFIG_DIR"

rm -rf "$CONFIG_DIR"/*
echo "[InspIRCd Add-on] Initializing default config…"
cp -r "$DEFAULTS_DIR/"* "$CONFIG_DIR/"
chown -R inspircd:inspircd "$CONFIG_DIR"

# 4) Run upstream entrypoint
exec /entrypoint.sh --runasroot "$@"