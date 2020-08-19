#!/bin/sh

# mailman.sh
# ==========
# A filter (as for mutt or aerc) which runs digestion and an awk filter.

if command -v /usr/local/share/mail-filters/digestion 2>&1 >/dev/null; then
  /usr/local/share/mail-filters/digestion -length $(tput cols) \
    | /usr/local/share/mail-filters/mailman.awk
else
    /usr/local/share/mail-filters/mailman.awk
fi

