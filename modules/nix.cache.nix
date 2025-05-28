{
  pkgs,
  fqdn,
  pathConfig,
  ...
}: let
  port = 5000;
  name = "nix-cache";

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/home/strass/.ssh/nix-cache-key";
    port = port;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
