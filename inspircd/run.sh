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

# 3) Overwrite with a minimal valid inspircd.conf
cat > "$CONFIG_DIR/inspircd.conf" <<EOF
<inspircd>

<server
  name="${SERVER_NAME}"
  description="${SERVER_DESCRIPTION}"
  network="${NETWORK_NAME}"
  id="1"
  hidden="no"
/>

<admin
  name="${ADMIN_NAME}"
  email="${ADMIN_EMAIL}"
  location="${ADMIN_LOCATION}"
/>

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
  sslcertfile="${CONFIG_DIR}/server.pem"
  sslkeyfile="${CONFIG_DIR}/server.key"
/>

<class name="default">
  <pingfreq>120</pingfreq>
  <sendq>100000</sendq>
  <recvq>8000</recvq>
  <timeout>45</timeout>
</class>

<connect class="default" />

<oper
  name="${ADMIN_NAME}"
  password="${ADMIN_PASSWORD}"
  class="default"
  flags="oO"
/>

<motd>
:Welcome to ${NETWORK_NAME}!
:Server: ${SERVER_NAME}
</motd>

</inspircd>
EOF

# 4) Run upstream entrypoint
exec /entrypoint.sh --runasroot "$@"