#!/bin/sh

# mailman.sh
# ==========
# A filter (as for mutt or aerc) which runs digestion and an awk filter.

DIGESTION_INSTALL_DIR=/usr/local/bin
MAILFILTERS_INSTALL_DIR=/usr/local/share/mail-filters

if command -v $DIGESTION_INSTALL_DIR/digestion 2>&1 >/dev/null; then
  $DIGESTION_INSTALL_DIR/digestion -length $(tput cols) \
    | $MAILFILTERS_INSTALL_DIR/mailman.awk
else
  $MAILFILTERS_INSTALL_DIR/mailman.awk
fi

