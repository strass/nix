{fqdn, ...}: let
  name = "sunshine";
  port = 47990;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
    method = "https"; # still doesn't work
  };
}
