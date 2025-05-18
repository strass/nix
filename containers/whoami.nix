{
  config,
  inputs,
  ...
}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers = {
      whoami = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          imports = [inputs.nix-topology.nixosModules.default];
          image = "docker.io/traefik/whoami:latest";
          exec = "--port=8081";
          autoUpdate = "registry";
          name = "whoami";
          publishPorts = ["0.0.0.0:8081:8081"];
          userns = "keep-id";
          hostname = "whoami";

          labels = [
            "traefik.enable=true"
            "traefik.http.routers.whoami.rule=Host'(`whoami.framework.local`)'"
            "traefik.http.services.whoami.loadbalancer.server.port=8081"
          ];
        };
      };
    };
    # networks = {
    # };
    # pods = {
    # };
  };

  networking.firewall.allowedTCPPorts = [
    8081
  ];
}
