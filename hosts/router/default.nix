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
    ../../modules/podman.nix
    ../../modules/fs.snapshots.nix
    ../../modules/fs.impermanence.nix

    ../../services/traefik.nix
    ../../services/nix.cache.nix
    # ../../services/cache.attic.nix
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

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-estuary.yaml";
  home-manager.users.strass.programs.starship.settings.hostname.ssh_symbol = "📡 ";

  # services.tftpd = {
  #   enable = true;
  #   path = "/srv/tftp";
  # };
}
