#!/bin/awk -f

# googlegroups.awk
# ================
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from @googlegroups.com, highlighting header information and hiding URLs.

BEGIN {
  in_header=0;
  do_not_print=0;

  dim="\033[2m";
  yellow="\033[33m";
  cyan="\033[36m";
  reset="\033[0m";
}
{
  # identify header section
  if (in_header==1 && $0 ~ /^={5,}/) in_header=0;
  else if ($0 ~ /^={5,}/) in_header=1;

  if (do_not_print==0) {
    if (in_header==1) {
      if ($0 ~ /^Topic:/) {
        $1=$1 dim cyan;
        $0=$0 reset;
      }
      else if ($0 ~ /^Url:/) {
        # skip printing this line
        do_not_print=1;
      }
    }
    else {
      if ($0 ~ /^(From|Date|Group):/) {
        $1=$1 dim cyan;
        $0=$0 reset;
      }
      else if ($0 ~ /^  - .* \[[1-9][0-9]? Updates?]/) {
        matched=match($0, /\[[1-9][0-9]? Updates?]/);
        if (matched!=0) {
          original=substr($0, RSTART, RLENGTH);
          replacement=reset yellow original reset;
          sub(/\[[1-9][0-9]? Updates?]/,replacement);

          # skip printing next line
          do_not_print=2;
          print dim cyan $0 reset;
        }
      }
      else if ($0 ~ /^-+ [1-9][0-9]? of [1-9][0-9]? -/) {
        $2=yellow $2;
        $4=$4 reset;
      }
      else if ($0 ~ /^Url: http/) {
        # skip printing this line
        do_not_print=1;
      }
      else if ($0 ~ /^Url:/) {
        # skip printing this AND next line
        do_not_print=2;
      }
    }
  }

  if (do_not_print==0) print $0;
  else do_not_print=do_not_print-1;
}


