{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  # paths = import ./config.nix;
in {
  imports = [
    inputs.nixos-facter-modules.nixosModules.facter
    # inputs.disko.nixosModules.disko
    ./hardware.nix
    ./backup.nix
    ./filesharing.nix
    #./disk-config.nix

    # Modules
    ../../modules/de.gnome.nix
    ../../modules/stylix.nix
    ../../modules/vscode.nix
    ../../modules/podman.nix

    # services
    # ../../services/auth.pocket-id.nix # only in unstable right now
    ../../services/avahi.nix
    ../../services/traefik.nix
    ../../services/database.redis.nix
    ../../services/database.postgres.nix
    ../../services/database.mysql.nix
    ../../services/olivetin.nix
    ../../services/ntfy.nix
    ../../services/backup.restic.nix

    # containers
    ../../containers/whoami.nix
    # ../../containers/backrest.nix
  ];

  facter.reportPath = ./facter.json;
  networking.useNetworkd = false; # using facter without this fails

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.strass = {
    packages = with pkgs; [
      moonlight-qt
      bitwarden-desktop
      bitwarden-cli
      discord
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty
  ];

  modules = {
    ssh.enable = true;
  };

  services.xserver.displayManager.gdm.wayland = false;
}
