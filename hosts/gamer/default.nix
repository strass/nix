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
    # ../../modules/fs.impermanence.nix

    ../../modules/de.gnome.nix
    ../../modules/gaming.nix
    ../../modules/stylix.nix
    ../../modules/podman.nix

    # ./backup.nix
  ];

  facter.reportPath = ./facter.json;
  networking.useNetworkd = false; # using facter without this fails

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11]; # do I need to change this for wayland?
    # kernelPackages = pkgs-unstable.linuxPackages_latest; # test if this is what is breaking driver builds
    kernelParams = ["pcie_aspm.policy=performance"];
  };

  networking.hostName = "gamer"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.users.strass = {
    packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
      discord
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty
    gnome-tweaks
  ];

  # Minecraft launcher
  # hm.home.packages = with pkgs; [prismlauncher];

  modules = {
    ssh.enable = true;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-forest.yaml";
}
