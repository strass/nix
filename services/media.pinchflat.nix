{}: let
  name = "pinchflat";
  port = 18881;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.pinchflat = {
    enable = true;
    mediaDir = "";
    openFirewall = true;
    port = port;
    secretsFile = "";
    selfhosted = true;
    extraConfig = "";
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
