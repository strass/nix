{config, ...}: {
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
            # "traefik.http.middlewares.hello-https-redirect.redirectscheme.scheme="https""
            # "traefik.http.routers.hello.middlewares='hello-https-redirect'"
            # "traefik.http.routers.hello-secure.entrypoints='websecure'"
            # "traefik.http.routers.hello-secure.rule=Host'(`hello.cthudson.com`)'"
            # "traefik.http.routers.hello-secure.tls=true"
            # "traefik.http.routers.hello-secure.tls.certresolver=lets-encrypt"
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
