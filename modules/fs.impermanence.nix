{...}: {
  fileSystems."/persist" = {
    device = "/dev/disk/by-partlabel/disk-nvme0n1-root";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime"];
  };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      # "/var/log"
      # "/var/lib/bluetooth"
      # "/var/lib/nixos"
      # "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      # {
      #   directory = "/var/lib/colord";
      #   user = "colord";
      #   group = "colord";
      #   mode = "u=rwx,g=rx,o=";
      # }
    ];
    files = [
      "/etc/machine-id"
    ];
    users.strass = {
      directories = [
        "Downloads"
        "Documents"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
      ];
      files = [
        ".screenrc"
      ];
    };
  };
}
# #!/usr/bin/env bash
# # fs-diff.sh
# # https://serverfault.com/questions/399894/does-btrfs-have-an-efficient-way-to-compare-snapshots
# # sudo mkdir /mnt ; sudo mount -o subvol=/ /dev/sda3 /mnt ; ./fs-diff.sh
# set -euo pipefail
# OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999)
# OLD_TRANSID=${OLD_TRANSID#transid marker was }
# sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
# sed '$d' |
# cut -f17- -d' ' |
# sort |
# uniq |
# while read path; do
#   path="/$path"
#   if [ -L "$path" ]; then
#     : # The path is a symbolic link, so is probably handled by NixOS already
#   elif [ -d "$path" ]; then
#     : # The path is a directory, ignore
#   else
#     echo "$path"
#   fi
# done
#
#
# https://github.com/chewblacka/nixos/blob/main/scripts/cruft.sh
# #!/usr/bin/env bash
# # fs-diff.sh
# echo "Script to list all the non-persistent cruft"
# echo "Written to root since the last boot"
# [ "$(id -u)" != 0 ] && exec sudo "$0"
# set -euo pipefail
# mkdir -p /mnt
# mount -o subvol=@ /dev/vda3 /mnt
# OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/root-blank 9999999)
# OLD_TRANSID=${OLD_TRANSID#transid marker was }
# sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
# sed '$d' |
# cut -f17- -d' ' |
# sort |
# uniq |
# while read path; do
#   path="/$path"
#   if [ -L "$path" ]; then
#     : # The path is a symbolic link, so is probably handled by NixOS already
#   elif [ -d "$path" ]; then
#     : # The path is a directory, ignore
#   else
#     echo "$path"
#   fi
# done
# umount /mnt

