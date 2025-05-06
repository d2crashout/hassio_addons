#!/usr/bin/env bash
set -e

# 1. Bootstrap your defaults into the persistent volume (only if empty)
if [ -n "${INSPIRCD_CONF}" ]; then
    echo "${INSPIRCD_CONF}" > /etc/inspircd/inspircd.conf
else
    # fallback to default
    cp /defaults/inspircd.conf /etc/inspircd/inspircd.conf
fi

# 2. Delegate to the upstream entrypoint, carrying through any args
exec /entrypoint.sh "$@"