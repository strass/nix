{
  inputs,
  pkgs,
  ...
}: let
  name = "pocket-id";
  port = 3000;
in {
  services.pocket-id = {
    enable = true;
    settings = {
      PUBLIC_APP_URL = "${name}.framework.local";
      DB_PROVIDER = "postgres";
      DB_CONNECTION_STRING = "postgres://pocket-id:pocket-id@localhost:5432/pocket-id";
      PORT = port;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
    ];
  };

  services.traefik.dynamicConfigOptions = {
    http.routers."${name}" = {
      rule = "Host(`${name}.framework.local`)";
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
