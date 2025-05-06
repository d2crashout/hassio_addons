#!/bin/sh
set -e

CONFIG_DIR=/inspircd/conf
DEFAULTS_DIR=/defaults

# 1) Ensure the config directory exists
mkdir -p "$CONFIG_DIR"

# 2) Bootstrap defaults once
if [ -z "$(ls -A "$CONFIG_DIR")" ]; then
  echo "[InspIRCd Add‑on] Initializing default config…"
  cp -r "$DEFAULTS_DIR/"* "$CONFIG_DIR/"
  chown -R inspircd:inspircd "$CONFIG_DIR"
fi

# 3) Overwrite with a minimal, valid config using your env vars
cat > "$CONFIG_DIR/inspircd.conf" <<EOF
<inspircd>

  <!-- Server identity -->
  <server
    name="${SERVER_NAME}"
    description="${SERVER_DESCRIPTION}"
    network="${NETWORK_NAME}"
    id="1"
    hidden="no"
  />

  <!-- Admin contact -->
  <admin
    name="${ADMIN_NAME}"
    email="${ADMIN_EMAIL}"
    location="${ADMIN_LOCATION}"
  />

  <!-- Bind blocks define where clients connect -->
  <bind
    address="0.0.0.0"
    port="${LISTEN_PORT}"
    type="clients"
  />
  <bind
    address="0.0.0.0"
    port="6697"
    type="clients"
    options="ssl"
    sslcertfile="/inspircd/conf/server.pem"
    sslkeyfile="/inspircd/conf/server.key"
  />

  <!-- Connection class -->
  <class name="default">
    <pingfreq>120</pingfreq>
    <sendq>100000</sendq>
    <recvq>8000</recvq>
    <timeout>45</timeout>
  </class>
  <connect class="default" />

  <!-- Operator account -->
  <oper
    name="${ADMIN_NAME}"
    password="${ADMIN_PASSWORD}"
    class="default"
    flags="oO"
  />

  <!-- MOTD -->
  <motd>
:Welcome to ${NETWORK_NAME}!
:Server: ${SERVER_NAME}
:Managed by Home Assistant
  </motd>

</inspircd>
EOF

exec /entrypoint.sh --runasroot "$@"