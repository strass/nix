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

    ../../modules/gnome.nix
    ../../modules/stylix.nix
    ../../services/avahi.nix
  ];

  facter.reportPath = ./facter.json;
  networking.useNetworkd = false; # using facter without this fails

  # Bootloader.
  boot = {
    loader.grub.enable = true;
    loader.grub.efiSupport = true;
    loader.grub.efiInstallAsRemovable = true;
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
}
