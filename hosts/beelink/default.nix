{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  # fqdn,
  ...
}: let
  mkTraefikService = import ../../util/mkTraefikService.nix;
in {
  imports = [
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    ../../modules/stylix.nix
    ../../modules/podman.nix
    ../../services/traefik.nix
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
  networking.hostName = "beelink";
  services.avahi.hostName = "home-assistant";
  services.avahi.domainName = "home-assistant.local";

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
    # openFirewall = true; # openFirewall can only be used with a declarative config
    # configure the path to your config directory
    configDir = "/var/lib/home-assistant";
    # specify list of components required by your configuration
    # extraComponents = [
    #   "esphome"
    #   "met"
    #   "radio_browser"
    # ];
    extraComponents = ["backup"];
    # extraPackages = ps: with ps; [psycopg2];
    # config.recorder.db_url = "postgresql://@/hass";
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = "home-assistant";
    port = 8123;
    fqdn = "local";
  };

  networking.firewall = {
    allowedTCPPorts = [8123];
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

  home-manager.users.strass.programs.starship.settings.hostname.ssh_symbol = "🏠 ";
}
