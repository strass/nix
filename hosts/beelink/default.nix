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
  ];

  facter.reportPath = ./facter.json;
  networking.useNetworkd = false; # using facter without this fails

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs-unstable.linuxPackages_latest;
    kernelParams = ["pcie_aspm.policy=performance"];
  };

  modules = {
    ssh.enable = true;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-forest.yaml";

  services.home-assistant = {
    enable = true;
    package = pkgs-unstable.home-assistant;
      # pkgs-unstable.home-assistant.override
      # ({
      #   extraPackages = py: with py; [];
      #   packageOverrides = final: prev: {
      #     certifi = prev.certifi.override {
      #       cacert = pkgs.cacert.override {
      #         # extraCertificateFiles = [./my_custom_root_ca.crt];
      #       };
      #     };
      #   };
      # }).overrideAttrs (oldAttrs: {
      #   doInstallCheck = false;
      # });
    # opt-out from declarative configuration management
    config = null;
    lovelaceConfig = null;
    # configure the path to your config directory
    configDir = "/var/lib/home-assistant";
    # specify list of components required by your configuration
    # extraComponents = [
    #   "esphome"
    #   "met"
    #   "radio_browser"
    # ];

    # extraPackages = ps: with ps; [psycopg2];
    # config.recorder.db_url = "postgresql://@/hass";
  };

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = ["hass"];
  #   ensureUsers = [
  #     {
  #       name = "hass";
  #       ensureDBOwnership = true;
  #     }
  #   ];
  # };
}
