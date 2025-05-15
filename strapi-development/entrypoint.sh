#!/bin/bash
set -e

is_effectively_empty() {
  # Check if directory contains only "lost+found" or is truly empty
  shopt -s nullglob dotglob
  files=("$1"/*)
  if [ ${#files[@]} -eq 0 ]; then
    return 0
  fi
  for f in "${files[@]}"; do
    base=$(basename "$f")
    if [[ "$base" != "lost+found" ]]; then
      return 1
    fi
  done
  return 0
}

echo "[bootstrap] Checking if /opt/app/src is empty..."
if is_effectively_empty "/opt/app/src"; then
  echo "[bootstrap] Initializing /opt/app/src"
  cp -r /opt/bootstrap-src/* /opt/app/src/
fi

echo "[bootstrap] Checking if /opt/app/config is empty..."
if is_effectively_empty "/opt/app/config"; then
  echo "[bootstrap] Initializing /opt/app/config"
  cp -r /opt/bootstrap-config/* /opt/app/config/
fi

# Continue with original entrypoint behavior
exec docker-entrypoint.sh ./entrypoint.sh && yarn develop
