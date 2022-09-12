#!/bin/awk -f

# freebsd.awk
# ===========
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from @freebsd.org, highlighting header information

BEGIN {
  in_header=0;

  dim="\033[2m";
  yellow="\033[33m";
  cyan="\033[36m";
  reset="\033[0m";
}
{
  # hide blocks of non-plaintext
  if (do_not_print==1 && $0 ~ /END PGP SIGNATURE/) do_not_print=0;
  else if ($0 ~ /BEGIN PGP SIGNATURE/) do_not_print=1;

  else {
    # identify header section
    if (in_header==1 && $0 ~ /^\s*$/) in_header=0;
    else if ($0 ~ /^(={5,}|(Topic|Category|Module|Announced|Credits|Affects|Corrected|CVE Name):)/) in_header=1;

    if (in_header==1) {
      # highlight header details while preserving whitespace
      if ($0 ~ /^(Topic|Category|Module|Announced|Credits|Affects|Corrected):/) {
        whitespace=substr("                ",length($1)+2)
        $2=whitespace dim cyan $2;
        $0=$0 reset;
      }
      else if ($0 ~ /^CVE Name:/) {
        whitespace=substr("                ",length($1)+length($2)+3)
        $3=whitespace dim cyan $3;
        $0=$0 reset;
      }
      else if ($0 !~ /^=/) {
        $0=dim cyan $0 reset;
      }
    }
    else {
      # highlight section titles
      if ($0 ~ /^(I|II|III|IV|V|VI|VII)\.\s/) {
        $0=yellow $0 reset;
      }
      else if ($0 ~ /^(1|2|3|4|a|b|c|d)\)\s/) {
        $1=yellow $1 reset;
      }
      # color syntax sections
      else if ($1=="#") {
        $0=cyan $0 reset;
      }
    }

    if (do_not_print==0) print $0;
  }
}


