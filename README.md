# mail-filters

My mail filters for `aerc` and/or `mutt`.

It's a set of text processing scripts that 'clean' plaintext email messages,
such as...

 + removing cruft and repetitive text
 + removing non-plaintext MIME parts
 + inserting ANSI color codes
 + standardizing whitespace

## Installation

Install [digestion](https://git.dominic-ricottone.com/~dricottone/digestion)
and [parcels](https://git.dominic-ricottone.com/~dricottone/parcels).

Run `sudo make install`.

## Uninstallation

Run `make uninstall`.

## Recommended aerc configuration:

In `aerc.conf`:

```
[filters]
text/html                     =/usr/local/share/mail-filters/html.sh
from,Archive of Our Own       =/usr/local/bin/parcels | /usr/local/share/mail-filters/ao3.awk
from,FanFiction               =/usr/local/bin/parcels | /usr/local/share/mail-filters/fanfiction.awk
from,ProPublica's Daily Digest=/usr/local/bin/parcels
to,~.@lists.ubuntu.com        =/usr/local/bin/parcels
to,~.@lists.debian.org        =/usr/local/bin/parcels | /usr/local/share/mail-filters/debian.awk
from,~.@freebsd.org           =/usr/local/bin/parcels | /usr/local/share/mail-filters/freebsd.awk
from,~.+@googlegroups.com     =/usr/local/bin/parcels | /usr/local/share/mail-filters/googlegroups.awk
from,~.+@lists.archlinux.org  =/usr/local/bin/digestion
from,~.+@python.org           =/usr/local/bin/digestion
from,~.+@gnu.org              =/usr/local/bin/digestion
text/*                        =/usr/local/bin/parcels
```


## Recommended mutt configuration

In `muttrc`:

```
set display_filter = "path/to/filter.sh"
```

And in `filter.sh`:

```
tmp=$(mktemp /tmp/filter.XXXXXXXX)
cat > "$TMP"

if grep --quiet -e '^From: Archive of Our Own' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels | /usr/local/share/mail-filters/ao3.awk
elif grep --quiet -e '^From: FanFiction' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels | /usr/local/share/mail-filters/fanfiction.awk
elif grep --quiet -e '^From: ProPublica\'s Daily Digest' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels
elif grep --quiet -e '^To:.*@lists.ubuntu.com' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels
elif grep --quiet -e '^To:.*@lists.debian.org' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels | /usr/local/share/mail-filters/debian.awk
elif grep --quiet -e '^From:.*@freebsd.org' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels | /usr/local/share/mail-filters/freebsd.awk
elif grep --quiet -e '^From:.*@googlegroups.com' "$TMP"; then
  cat "$TMP" | /usr/local/bin/parcels | /usr/local/share/mail-filters/googlegroups.awk
elif grep --quiet -e '^From:.*@archlinux.org' "$TMP"; then
  cat "$TMP" | /usr/local/bin/digestion
elif grep --quiet -e '^From:.*@python.org' "$TMP"; then
  cat "$TMP" | /usr/local/bin/digestion
elif grep --quiet -e '^From:.*@gnu.org' "$TMP"; then
  cat "$TMP" | /usr/local/bin/digestion
else
  cat "$TMP" | /usr/local/bin/parcels
fi

rm -f "$TMP"
```

## License

All materials of this repository are licensed under BSD-3. A copy is included
here as `LICENSE.md`.

