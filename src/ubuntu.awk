#!/bin/awk -f

# ubuntu.awk
# ==========
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# to @lists.ubuntu.com, highlighting header information and hiding URLs

BEGIN {
  in_header=0;
  in_references=0;
  do_not_print_blank=0;

  dim="\033[2m";
  cyan="\033[36m";
  reset="\033[0m";

  colon_replacement=": " reset
}
{
  # identify header/references section
  if (in_header==1 && $0 ~ /^={5,}/) in_header=0;
  else if ($0 ~ /^={5,}/) in_header=1;
  else if (in_references==1 && $0 ~ /^\s+$/) in_references=0;
  else if ($0 ~ /^References:/) in_references=1;

  if (in_header==1) {
    if ($0 !~ /={5,}/) {
      $0=dim cyan $0 reset;
    }
  }
  else {
    # skip next line if blank
    if ($0 ~ /^(A security issue affects|Summary|Details|Software Description|Update instructions):/) do_not_print_blank=2;

    # highlight header details (except references)
    if ($0 ~ /^- [A-Za-z]/) {
      $2=dim cyan $2;
      $0=$0 reset;
      sub(/: /,colon_replacement);
    }
    else if (in_references==0 && $0 ~ /^  [A-Za-z]/) {
      $1=dim cyan $1 reset;
      $0="  " $0;
    }
  }

  if (do_not_print_blank==0) print $0;
  else {
    if ($0 !~ /^\s*$/) print $0;
    do_not_print_blank=do_not_print_blank-1;
  }
}


