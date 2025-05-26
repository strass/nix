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

  # services.snapper = {
  #   enable = true;
  #   snapshotRootOnBoot = true;
  #   configs = {
  #     home = {
  #       SUBVOLUME = "/home";
  #       ALLOW_USERS = ["strass"];
  #       TIMELINE_CREATE = true;
  #       TIMELINE_CLEANUP = true;
  #     };
  #   };
  # };

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
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".nixops";
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
