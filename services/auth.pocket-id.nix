{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "pocket-id";
  port = 3000;
in {
  services.pocket-id = {
    enable = true;
    settings = {
      PUBLIC_APP_URL = "${name}.${fqdn}";
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

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    port = port;
    fqdn = fqdn;
  };
}
