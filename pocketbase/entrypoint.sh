#!/bin/sh
set -e

DATA_DIR=/pb_data
PUBLIC_DIR=/pb_public
HOOKS_DIR=/pb_hooks

EMAIL=${PB_ADMIN_EMAIL:-}
PASSWORD=${PB_ADMIN_PASSWORD:-}


# Upsert first super-user if email and password are provided
if [ -n "$EMAIL" ] && [ -n "$PASSWORD" ]; then
  echo ">> Ensuring super-user $EMAIL exists…"
  /usr/local/bin/pocketbase --dir "$DATA_DIR" superuser upsert "$EMAIL" "$PASSWORD"
fi

exec /usr/local/bin/pocketbase serve \
     --http 0.0.0.0:8090 \
     --dir "$DATA_DIR" \
     --publicDir "$PUBLIC_DIR" \
     --hooksDir "$HOOKS_DIR"
