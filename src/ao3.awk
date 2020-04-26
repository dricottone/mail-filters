#!/bin/awk -f

# ao3.awk
# =======
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from Archive of Our Own (AO3), highlighting descriptive information

BEGIN {
  highlight="\033[44m";
  dim="\033[2m";
  cyan="\033[36m";
  reset="\033[0m";

  comma_replacement=reset ", " highlight;
}
{
  # stop processing at end of mail, marked by dashed line
  if ($0 ~ /^-+\s*/) exit 0;

  if ($0 ~ /\([1-9][0-9]* words\)/) {
    matched=match($0, /\([1-9][0-9]* words\)/);
    if (matched!=0) {
      original=substr($0, RSTART, RLENGTH);
      replacement=reset dim cyan original reset;
      sub(/\([1-9][0-9]* words\)/,replacement);
    }
  }

  if ($0 ~ /posted a (new|backdated)/) {
    sub(/\(http.*\) posted/,"posted");
    $1=dim cyan $1 reset;
  }
  else if ($0 ~ /^by/) {
    sub(/ \(http.*\)/,"");
    $2=dim cyan $2 reset;
  }
  else if ($0 ~ /^(Chapters|Fandom|Rating|Warnings):/) {
    $1=$1 dim cyan;
    $0=$0 reset;
  }
  else if ($0 ~ /^(Relationships|Characters):/) {
    gsub(/, /,comma_replacement);
    $2=highlight $2
    $0=$0 reset
  }
  else if ($0 ~ /^Additional Tags:/) {
    gsub(/, /,comma_replacement);
    $3=highlight $3
    $0=$0 reset
  }

  print $0;
}

