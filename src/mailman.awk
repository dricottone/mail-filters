#!/bin/awk -f

# mailman.awk
# ===========
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from mailman servers, highlighting header information

BEGIN {
  in_todays_topics=0;
  in_header=0;
  do_not_print=0;

  get_boundary=0;
  boundary="";

  dim="\033[2m";
  yellow="\033[33m";
  cyan="\033[36m";
  reset="\033[0m";
}
{
  # get boundary
  if (get_boundary==1) {
    get_boundary=0;
    matched=match($0,/boundary=".*"/);
    if (matched!=0) boundary="--" substr($0,RSTART+10,RLENGTH-11);
    # if failed to extract boundary, resume printing
    else do_not_print=0;
  }

  # skip blocks of non-text (HTML, PGP Signatures, non-text MIME parts)
  if (do_not_print==1 && $0 ~ /(<\/html>|END PGP SIGNATURE)/) do_not_print=0;
  else if (boundary!="" && $0 ~ boundary) do_not_print=0;

  else if ($0 ~ /(<html>|BEGIN PGP SIGNATURE)/) do_not_print=1;
  else if ($0 ~ /^Content-Type:/) {
    in_header=0;
    if ($0 ~ /multipart\/alternative/) { do_not_print=1; get_boundary=1; }
    else if (boundary!="" && $0 ~ /text\/html/) do_not_print=1;
    # for other content types, resume printing
    else do_not_print=0;
  }

  else {
    # identify "Today's Topics" section
    if (in_todays_topics==1 && $0 ~ /^-{5,}/) in_todays_topics=0;
    else if ($0 ~ /^Today's Topics:/) in_todays_topics=1;

    # identify header section
    if (in_header==1 && $0 ~ /^\s*$/) { in_header=0; do_not_print=0; }
    else if ($0 ~ /^(Message|Date|From|To|Subject|Message-ID):/) in_header=1;

    if (in_todays_topics==1) {
      matched=match($0, /\(.+\)/);
      if (matched!=0) {
        original=substr($0, RSTART, RLENGTH);
        replacement=reset original;
        sub(/\(.+\)/,replacement);
      }
      if ($0 ~ /^ +[1-9][0-9]?\./) {
        $1=$1 dim cyan;
        $0=$0 reset;
      }
      else if ($0 !~ /^Today's Topics:/) {
        $0=dim cyan $0 reset
      }
    }
    else if (in_header==1) {
      if ($0 ~ /^(Date|From|Subject):/) {
        do_not_print=0;
        $1=$1 dim cyan;
        $0=$0 reset;
      }
      else if ($0 ~ /^Message:/) {
        do_not_print=0;
        $1=$1 yellow;
        $0=$0 reset;
      }
      else if ($0 ~ /^(To|Message-ID):/) {
        do_not_print=1;
      }
      else {
        $0=dim cyan $0 reset;
      }
    }

    if (do_not_print==0) print $0;
  }
}

