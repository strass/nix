{
  pkgs,
  lib,
  ...
}: let
  cruftScript = pkgs.writeShellScriptBin "find-changed" (builtins.readFile ../scripts/cruft.sh);
  motdScript = pkgs.writeShellScriptBin "update-motd" ''
    #!/bin/sh
    echo "$(${cruftScript}/bin/find-changed)" > /etc/motd
  '';
in {
  # fileSystems."/persist" = {
  #   device = "/dev/disk/by-partlabel/disk-nvme0n1-root";
  #   neededForBoot = true;
  #   fsType = "btrfs";
  #   options = ["subvol=persist" "compress=zstd" "noatime"];
  # };
  # environment.persistence."/persist" = {
  #   hideMounts = true;
  #   directories = [
  #     # "/var/log"
  #     # "/var/lib/bluetooth"
  #     # "/var/lib/nixos"
  #     # "/var/lib/systemd/coredump"
  #     "/etc/NetworkManager/system-connections"
  #     # {
  #     #   directory = "/var/lib/colord";
  #     #   user = "colord";
  #     #   group = "colord";
  #     #   mode = "u=rwx,g=rx,o=";
  #     # }
  #   ];
  #   files = [
  #     "/etc/machine-id"
  #   ];
  #   users.strass = {
  #     directories = [
  #       "Downloads"
  #       "Documents"
  #       {
  #         directory = ".gnupg";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".ssh";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".local/share/keyrings";
  #         mode = "0700";
  #       }
  #       ".local/share/direnv"
  #     ];
  #     files = [
  #       ".screenrc"
  #     ];
  #   };
  # };

  # Systemd service that runs the script
  systemd.services.update-motd = {
    description = "Update /etc/motd with dynamic content";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "PATH=$PATH:${lib.makeBinPath [pkgs.btrfs-progs]} ${motdScript}/bin/update-motd";
    };
  };

  # Systemd timer that runs the service every hour
  systemd.timers.update-motd = {
    description = "Run update-motd every hour";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };
  };
}
