{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "rtorrent";
  port = 13212;

  mkTraefikService = import ../../util/mkTraefikService.nix;
in {
  services.flood = {
    enable = true;
    host = "localhost";
    port = port;
    openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
