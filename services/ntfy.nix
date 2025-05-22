{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "ntfy";
  port = 8888;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${name}.${fqdn}";
      listen-http = ":${toString port}";
    };
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
