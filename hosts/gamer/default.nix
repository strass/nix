# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  # Not sure why this is needed
  # TODO: remove
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  imports = [
    ./hardware.nix
    # inputs.nixos-facter-modules.nixosModules.facter

    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ../../modules/gaming.nix
    ../../modules/stylix.nix
    # ../../modules/vscode.nix
    # ../../modules/podman.nix
  ];

  # config.facter.reportPath = ./facter.json;
  # facter.reportPath = ./facter.json;

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = ["nvidia"];
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    kernelPackages = pkgs-unstable.linuxPackages_latest;
    kernelParams = ["pcie_aspm.policy=performance"];
  };

  networking.hostName = "gamer"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Ensure gnome-settings-daemon udev rules are enabled.
  services.udev.packages = with pkgs; [gnome-settings-daemon];
  services.xserver = {
    # Required for DE to launch.
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    # Enable Desktop Environment.
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ];

  programs.dconf.enable = true;

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
      bitwarden-desktop
      bitwarden-cli
      discord
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "strass";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty
    gnome-tweaks
  ];

  modules = {
    ssh.enable = true;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-forest.yaml";

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
