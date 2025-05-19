{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "ntfy";
  port = 8888;
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
