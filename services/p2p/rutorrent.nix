{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "rtorrent";
  port = 132012;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.rutorrent = {
    enable = true;
    dataDir = "/var/lib/rutorrent";
    hostName = "${name}.${fqdn}";
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
