{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    ../../modules/de.gnome.nix
    ../../modules/stylix.nix
    ../../services/avahi.nix
  ];

  facter.reportPath = ./facter.json;
  networking.useNetworkd = false; # using facter without this fails

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs-unstable.linuxPackages_hardened;
    kernelParams = ["pcie_aspm.policy=performance"];
  };

  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty
  ];

  modules = {
    ssh.enable = true;
  };

  services.snapper = {
    snapshotRootOnBoot = true;
    configs = {
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = ["strass"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = ["strass"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
    };
  };
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

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-estuary.yaml";
}
