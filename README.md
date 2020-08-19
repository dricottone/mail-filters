# mail-filters

A set of text processing scripts that 'clean' plaintext email messages. This includes

 + removing cruft and repetitive text
 + removing non-plaintext MIME parts
 + inserting ANSI color codes
 + standardizing whitespace



## Installation

Run `sudo make install`. All it's going to do is copy the filters to /usr/local/share, though. I don't know why I even wrote this.



## Uninstallation

Run `make uninstall`. Again, all we're doing is copying files... This is a bit much...



## Recommended aerc configuration:

In `aerc.conf`:

```
[filters]
text/html                =path/to/html.sh
from,Archive of Our Own  =path/to/ao3.awk
from,FanFiction          =path/to/fanfiction.awk
to,~.@lists.ubuntu.com   =path/to/ubuntu.awk
to,~.@lists.debian.org   =path/to/debian.awk
from,~.@freebsd.org      =path/to/freebsd.awk
from,~.+@googlegroups.com=path/to/googlegroups.awk
from,~.+@archlinux.org   =path/to/mailman.sh
from,~.+@python.org      =path/to/mailman.sh
from,~.+@gnu.org         =path/to/mailman.sh
text/*                   =cat
```

If possible, install [digestion](https://git.dominic-ricottone.com/digestion) as well. `mailman.sh` will automatically make use of it.


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
  cat "$TMP" | path/to/ao3.awk
elif grep --quiet -e '^From: FanFiction' "$TMP"; then
  cat "$TMP" | path/to/fanfiction.awk
elif grep --quiet -e '^To:.*@lists.ubuntu.com' "$TMP"; then
  cat "$TMP" | path/to/ubuntu.awk
elif grep --quiet -e '^To:.*@lists.debian.org' "$TMP"; then
  cat "$TMP" | path/to/debian.awk
elif grep --quiet -e '^From:.*@freebsd.org' "$TMP"; then
  cat "$TMP" | path/to/freebsd.awk
elif grep --quiet -e '^From:.*@googlegroups.com' "$TMP"; then
  cat "$TMP" | path/to/googlegroups.awk
elif grep --quiet -e '^From:.*@archlinux.org' "$TMP"; then
  cat "$TMP" | path/to/mailman.sh
elif grep --quiet -e '^From:.*@python.org' "$TMP"; then
  cat "$TMP" | path/to/mailman.sh
elif grep --quiet -e '^From:.*@gnu.org' "$TMP"; then
  cat "$TMP" | path/to/mailman.sh
else
  cat "$TMP"
fi

rm -f "$TMP"
```



## License

All materials of this repository are licensed under BSD-3. A copy of this license is included in the file LICENSE.md.

