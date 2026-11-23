#!/bin/sh
set -eu

umask 077
# Use the container boundary instead of requiring extra privileges for Electron.
set -- /opt/beeper/AppRun --no-sandbox
# The Wayland session does not always provide a D-Bus session bus.
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    set -- dbus-run-session -- "$@"
fi
exec "$@" > /config/beeper.log 2>&1
