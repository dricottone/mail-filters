#!/bin/sh

# open-in-browser.sh
# ==================
# A wrapper around parcels which opens a selected URL in a browser.

PARCELS_INSTALL_DIR=/usr/local/bin
BROWSER=firefox

url="$($PARCELS_INSTALL_DIR/parcels -n "$1")"
if [ -z "$url" ]; then
  exit 1
fi
exec $BROSWER "$url"

