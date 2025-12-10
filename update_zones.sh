#!/bin/sh

apk add --no-cache curl

while true; do
  echo '---------------------------------------------------'
  echo 'Starting update routine...'

  # 1. Root Hints
  echo 'Downloading Root Hints...'
  curl -s $ROOT_HINTS_URL -o $HINTS_FILE
  echo 'Root Hints Saved.'

  # 2. Blocklist (Unbound Format)
  echo 'Downloading Blocklist...'

  # Clear the file first
  echo "# Adblock List for Unbound" >$ZONE_FILE

  # Download, filter 0.0.0.0, and format as: local-zone: "domain" always_null
  # 'always_null' returns 0.0.0.0 (like you wanted)
  curl -s $BLOCKLIST_URL | grep '^0\.0\.0\.0' | grep -v '0.0.0.0 0.0.0.0' | awk '{print "local-zone: \"" $2 "\" always_null"}' >>$ZONE_FILE

  echo 'Blocklist Saved.'

  # Reload Unbound to apply changes (if running)
  # We use pkill to send SIGHUP which tells Unbound to reload config
  if pgrep unbound >/dev/null; then
    echo "Reloading Unbound..."
    pkill -HUP unbound
  fi

  echo 'All updates complete. Sleeping for 24 hours...'
  echo '---------------------------------------------------'
  sleep 86400
done
