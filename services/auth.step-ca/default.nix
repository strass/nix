{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "step-ca";
  port = 8443;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.step-ca = {
    enable = true;
    port = port;
    openFirewall = true;
    settings = builtins.fromJSON builtins.readFile ./ca.json;
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    port = port;
    fqdn = fqdn;
  };
}
