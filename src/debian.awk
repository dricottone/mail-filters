#!/bin/awk -f

# debian.awk
# ================
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# to @lists.debian.com, highlighting header information

BEGIN {
  in_header=0;
  do_not_print=0;

  dim="\033[2m";
  yellow="\033[33m";
  cyan="\033[36m";
  reset="\033[0m";

  _releases = "oldstable stable testing unstable squeeze wheezy jessie stretch buster";
  split(_releases,releases," ");
}
{
  # hide blocks of non-plaintext
  if (do_not_print==1 && $0 ~ /END PGP SIGNATURE/) do_not_print=0;
  else if ($0 ~ /BEGIN PGP SIGNATURE/) do_not_print=1;

  else {
    # identify header section
    if (in_header==1 && $0 ~ /^-\s+-{5,}/ || $0 ~ /^\s*$/) in_header=0;
    else if ($0 ~ /^(-\s+-{5,}|(Package|CVE ID)\s*:)/) in_header=1;

    if (in_header==1) {
      if ($0 ~ /^Package\s*:/) {
        whitespace=substr("                ",length($1)+3)
        $3=whitespace dim cyan $3;
        $0=$0 reset;
      }
      else if ($0 ~ /^(CVE ID|Debian Bug)\s*:/) {
        whitespace=substr("                ",length($1)+length($2)+4)
        $4=whitespace dim cyan $4;
        $0=$0 reset;
      }
      else if ($0 !~ /^-/) {
        $0=dim cyan $0 reset;
      }
    }
    else {
      if ($0 ~ /^Mailing list:/) {
        $3=dim cyan $3;
        $0=$0 reset;
      }
      for (i in releases) {
        replacement=yellow releases[i] reset;
        gsub(releases[i],replacement);
      }
    }

    if (do_not_print==0) print $0;
  }
}


