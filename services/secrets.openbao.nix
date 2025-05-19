{
  inputs,
  pkgs,
  fqdn,
  ...
}: let
  name = "openbao";
  port = 6200;
  port2 = 6201;
in {
  services.openbao = {
    package = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}".openbao;
    enable = true;

    settings = {
      ui = true;
      cluster_addr = "https://127.0.0.1:${toString port2}";
      api_addr = "https://127.0.0.1:${toString port}";

      listener.default = {
        type = "tcp";
      };

      storage.raft.path = "/var/lib/openbao";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      port
      port2
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
