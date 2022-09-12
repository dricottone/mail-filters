#!/bin/awk -f

# fanfiction.awk
# ==============
# A filter (as for mutt or aerc) intended to clean & decorate plaintext mail
# from FanFiction.net, dim cyaning descriptive information

BEGIN {
  dim="\033[2m";
  cyan="\033[36m";
  reset="\033[0m";

  skip=0;

  comma_replacement=reset ", " dim cyan;
  brace_replacement=reset "] " dim cyan;
  close_brace_replacement=reset "] ";
}
{
  # stop processing at end of mail, marked by website URL
  if ($0 ~ /^FanFiction \[/) skip=1;
  if ($0 ~ /^URLs:/) skip=0;

  if ($0 ~ /^New (story|chapter) from/) {
    $4=cyan $4;
    $0=$0 reset;
  }
  else if ($0 ~ /^(Words|Genre|Rated):/) {
    $1=$1 dim cyan;
    $0=$0 reset;
  }
  else if ($0 ~ /^Character:/) {
    if ($2 ~ /^\[/) {
      $2="[" dim cyan substr($2,2);
    }
    else {
      $2=dim cyan $2;
    }
    gsub(/, /,comma_replacement);
    gsub(/\] /,brace_replacement);
    if ($NF ~ /]\s+$/) {
      sub(/]\s+$/,close_brace_replacement,$NF);
    }
    else {
      $0=$0 reset;
    }
  }

  if (skip==0) print $0;
}

