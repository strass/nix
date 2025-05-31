#!/usr/bin/env bash
# fs-diff.sh
# https://github.com/chewblacka/nixos/blob/main/scripts/cruft.sh
echo "Script to list all the non-persistent cruft"
echo "Written to root since the last boot"
[ "$(id -u)" != 0 ] && exec sudo "$0"

set -euo pipefail

SUBVOLUME="/home"
OLD_TRANSID=$(sudo btrfs subvolume find-new ${SUBVOLUME} 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

sudo btrfs subvolume find-new ${SUBVOLUME} "$OLD_TRANSID" |
sed '$d' |
cut -f17- -d' ' |
sort |
uniq |
while read path; do
  path="/$path"
  if [ -L "$path" ]; then
    : # The path is a symbolic link, so is probably handled by NixOS already
  elif [ -d "$path" ]; then
    : # The path is a directory, ignore
  else
    echo "$path"
  fi
done