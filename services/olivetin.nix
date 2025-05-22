{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "olivetin";
  port = 8200;

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.olivetin = {
    package = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}".olivetin;

    group = "podman";
    user = "olivetin";
    enable = true;
    settings = {
      ListenAddressSingleHTTPFrontend = "0.0.0.0:${toString port}";
      actions = [
        {
          id = "gamer_wol";
          title = "Gaming PC Wake on LAN";
          shell = "wol -v -h 192.168.1.123 2c:4d:54:d7:80:11";
          icon = "ping";
        }
      ];
    };
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };

  users.users.olivetin = {
    isSystemUser = true;
    home = "/var/lib/olivetin";
    packages = with pkgs; [
      wol
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };
}
