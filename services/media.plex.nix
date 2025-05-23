{}: let
  name = "plex";
  port = 32400;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  nixpkgs.config.allowUnfree = true; # Plex is unfree

  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";

    managePlugins = true;
    extraPlugins = [];
  };

  networking.firewall = {
    # allowedTCPPorts = [3005 8324 32469];
    # allowedUDPPorts = [1900 5353 32410 32412 32413 32414];
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
