#!/bin/sh

# html.sh
# =======
# A filter (as for mutt or aerc) which runs w3m--vendored from a filter
# bundled with aerc

w3m -T text/html -cols $(tput cols) -dump -o display_image=false -o display_link_number=true

