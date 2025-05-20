{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "olivetin";
  port = 8200;
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

  services.traefik.dynamicConfigOptions = {
    http.routers."${name}" = {
      rule = "Host(`${name}.${fqdn}`)";
      service = name;
    };
    http.services."${name}" = {
      loadBalancer.servers = [
        {
          url = "http://localhost:${toString port}";
        }
      ];
    };
  };
}
