#!/usr/bin/env bash
set -euo pipefail

echo "📅 Changed files since last boot"
echo "Generated $(date)"
echo "------------------------------------------"
echo ""

# Extract subvolumes, normalize paths
ALL_SUBVOLUMES=$(
  sudo btrfs subvolume list -a / | awk '
{
  path = $NF
  gsub("^<FS_TREE>/@", "", path)
  gsub("^@", "", path)
  # Fix paths like "var-log" → "var/log"
  gsub("-", "/", path) # fallback: convert other dashes to slashes
  print path
}' | sort -u
)

for SUBVOLUME in $ALL_SUBVOLUMES; do
  echo "🔍 ${SUBVOLUME}"
  echo "------------------------------------------"

  # Try to get transid; skip subvolume if it fails
  if ! OLD_TRANSID_OUTPUT=$(sudo btrfs subvolume find-new "${SUBVOLUME}" 9999999 2>/dev/null); then
    echo "⚠️  Skipping: Not a valid sudo btrfs subvolume or inaccessible"
    echo ""
    continue
  fi

  OLD_TRANSID=${OLD_TRANSID_OUTPUT#transid marker was }

  CHANGED=$(sudo btrfs subvolume find-new "${SUBVOLUME}" "$OLD_TRANSID" 2>/dev/null |
    sed '$d' | cut -f17- -d' ' | sort -u |
    while read -r path; do
      full_path="/$path"
      if [[ -L "$full_path" || -d "$full_path" ]]; then
        continue
      fi
      echo "${SUBVOLUME}${full_path}"
    done)

  if [[ -n "$CHANGED" ]]; then
    echo "$CHANGED"
  else
    echo "✅ No changed files."
  fi

  echo ""
done
