#!/bin/awk -f

# mailman.awk
# ===========
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from mailman servers, highlighting header information

BEGIN {
  in_todays_topics=0;
  do_not_print=0;

  dim="\033[2m";
  cyan="\033[36m";
  reset="\033[0m";
}
{
  # skip blocks of non-text (HTML, PGP Signatures, non-text MIME parts)
  if (do_not_print==1 && $0 ~ /(<\/html>|END PGP SIGNATURE)/) do_not_print=0;
  else if ($0 ~ /(<html>|BEGIN PGP SIGNATURE)/) do_not_print=1;

  else {
    # identify "Today's Topics"
    if (in_todays_topics==1 && $0 ~ /^-{5,}/) in_todays_topics=0;
    else if ($0 ~ /^Today's Topics:/) in_todays_topics=1;

    # highlight "Today's Topics"
    if (in_todays_topics==1) {
      matched=match($0, /\([^)]+\)/);
      if (matched!=0) {
        original=substr($0, RSTART, RLENGTH);
        replacement=reset original;
        sub(/\([^)]+\)/,replacement);
      }
      if ($0 ~ /^ +[1-9][0-9]?\./) {
        $1=$1 dim cyan;
        $0=$0 reset;
      }
      else if ($0 !~ /^Today's Topics:/) {
        $0=dim cyan $0 reset
      }
    }

    # highlight header lines
    else if ($0 ~ /^(Subject|Date|From|To|Cc):/) {
      $1=$1 dim cyan;
      $0=$0 reset;
    }

    if (do_not_print==0) print $0;
  }
}

