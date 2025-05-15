#!/bin/bash
set -e

echo "[bootstrap] Checking if /opt/app/src is empty..."
if [ -z "$(ls -A /opt/app/src 2>/dev/null)" ]; then
  echo "[bootstrap] Initializing /opt/app/src"
  cp -r /opt/bootstrap-src/* /opt/app/src/
fi

echo "[bootstrap] Checking if /opt/app/config is empty..."
if [ -z "$(ls -A /opt/app/config 2>/dev/null)" ]; then
  echo "[bootstrap] Initializing /opt/app/config"
  cp -r /opt/bootstrap-config/* /opt/app/config/
fi

# Now continue with original entrypoint and command
exec docker-entrypoint.sh ./entrypoint.sh && yarn develop
