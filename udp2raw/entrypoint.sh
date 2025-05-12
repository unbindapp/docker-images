#!/bin/bash
set -e

# Default values
MODE=${UDP2RAW_MODE:-"server"}              # server or client
LOCAL_ADDR=${UDP2RAW_LOCAL_ADDR:-"0.0.0.0"} # Local bind address
LOCAL_PORT=${UDP2RAW_LOCAL_PORT:-"51821"}   # Local bind port
REMOTE_ADDR=${UDP2RAW_REMOTE_ADDR:-"127.0.0.1"} # Remote address
REMOTE_PORT=${UDP2RAW_REMOTE_PORT:-"51820"} # Remote port
SECRET_KEY=${UDP2RAW_KEY:-"change_this_key"} # Secret key for auth/encryption
RAW_MODE=${UDP2RAW_RAW_MODE:-"faketcp"}     # faketcp, udp, icmp, etc.
CIPHER=${UDP2RAW_CIPHER:-"aes128cbc"}       # Cipher for encryption
AUTH=${UDP2RAW_AUTH:-"md5"}                 # Auth algorithm
LOG_LEVEL=${UDP2RAW_LOG_LEVEL:-"info"}      # Log level
MTU=${UDP2RAW_MTU:-"1500"}                  # MTU
SOCK_BUFF=${UDP2RAW_SOCK_BUFF:-"1024"}      # Socket buffer size in KB

# Resolve DNS if needed (important for Kubernetes)
if [[ "$MODE" == "client" && "$REMOTE_ADDR" != "127.0.0.1" && ! "$REMOTE_ADDR" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Resolving DNS for $REMOTE_ADDR..."
  RESOLVED_IP=$(getent hosts "$REMOTE_ADDR" | awk '{ print $1 }')
  
  if [[ -n "$RESOLVED_IP" ]]; then
    echo "Resolved $REMOTE_ADDR to $RESOLVED_IP"
    REMOTE_ADDR=$RESOLVED_IP
  else
    echo "Warning: Could not resolve $REMOTE_ADDR, using as-is"
  fi
fi

# Build command based on mode
if [[ "$MODE" == "server" ]]; then
  # Server mode
  CMD_ARGS="-s -l${LOCAL_ADDR}:${LOCAL_PORT} -r${REMOTE_ADDR}:${REMOTE_PORT}"
elif [[ "$MODE" == "client" ]]; then
  # Client mode
  CMD_ARGS="-c -l${LOCAL_ADDR}:${LOCAL_PORT} -r${REMOTE_ADDR}:${REMOTE_PORT}"
else
  echo "Error: Invalid mode. Must be 'server' or 'client'"
  exit 1
fi

# Add common arguments
CMD_ARGS="$CMD_ARGS -k \"$SECRET_KEY\" --raw-mode $RAW_MODE --cipher-mode $CIPHER --auth-mode $AUTH"
CMD_ARGS="$CMD_ARGS --log-level $LOG_LEVEL --mtu-warn $MTU --sock-buf $SOCK_BUFF"

# Add any additional arguments
if [[ -n "$UDP2RAW_ADDITIONAL_ARGS" ]]; then
  CMD_ARGS="$CMD_ARGS $UDP2RAW_ADDITIONAL_ARGS"
fi

# Print the command (without secret key) for debugging
SANITIZED_CMD=$(echo "$CMD_ARGS" | sed "s/-k \"[^\"]*\"/-k \"****\"/g")
echo "Starting udp2raw with: $SANITIZED_CMD"

# Execute the command
eval "exec /usr/local/bin/udp2raw $CMD_ARGS"