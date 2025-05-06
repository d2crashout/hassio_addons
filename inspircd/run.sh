#!/usr/bin/env sh
set -e

CONFIG_DIR=/inspircd/conf
mkdir -p "$CONFIG_DIR"

# ————————————————————————————————
# Defaults (override via add‑on options in config.json)
# ————————————————————————————————
: "${SERVER_NAME:=irc.example.com}"
: "${SERVER_DESCRIPTION:=InspIRCd Server}"
: "${NETWORK_NAME:=HomeIRCd}"
: "${ADMIN_NAME:=admin}"
: "${ADMIN_EMAIL:=admin@example.com}"
: "${ADMIN_LOCATION:=Home}"
: "${ADMIN_PASSWORD:=changeme}"
: "${LISTEN_PORT:=6667}"
: "${USER_NICK:=homebot}"
: "${USER_NAME:=homebot}"
: "${USER_REALNAME:=Home Assistant Bot}"

# ————————————————————————————————
# Generate inspircd.conf
# ————————————————————————————————
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

  <listen
    address="0.0.0.0"
    port="${LISTEN_PORT}"
    options="ipv4"
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

  <user
    nick="${USER_NICK}"
    name="${USER_NAME}"
    realname="${USER_REALNAME}"
  />

  <!-- Load any extra modules you need -->
  <module name="m_cmd_oper.so" />
  <module name="m_spanningtree.so" />

  <motd>
:Welcome to ${NETWORK_NAME}!
:------------------------------------
:  Server: ${SERVER_NAME}
:  Managed by Home Assistant
------------------------------------
  </motd>
</inspircd>
EOF

# ————————————————————————————————
# Delegate to the official entrypoint (preserves certs, DH params, etc.)
# ————————————————————————————————
exec /entrypoint.sh --runasroot "$@"