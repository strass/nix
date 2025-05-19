# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./hardware.nix
    ./filesharing.nix

    ../../modules/gnome.nix
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

    # containers
    ../../containers/whoami.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty
  ];

  modules = {
    ssh.enable = true;
  };

  services.xserver.displayManager.gdm.wayland = false;
}
