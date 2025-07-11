{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "rtorrent";
  port = 13212;

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
