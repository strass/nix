{
  config,
  fqdn,
  pathConfig,
  ...
}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers = {
      # not working because it cant access localhost
      backrest = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
          environment = [
            "BACKREST_DATA=/data"
            "BACKREST_CONFIG=/config/config.json"
            "XDG_CACHE_HOME=/cache"
            "TMPDIR=/tmp"
            "TZ=America/Los_Angeles"
          ];
        };
        containerConfig = {
          image = "docker.io/garethgeorge/backrest:latest";
          autoUpdate = "registry";
          name = "backrest";
          publishPorts = ["0.0.0.0:9898:9898"];
          userns = "keep-id";
          hostname = "backrest";
          volumes = [
            # "${pathConfig.appConfig.root}/restic/data:/data"
            # "${pathConfig.appConfig.root}/backrest/config:/config"
            # "${pathConfig.appConfig.root}/backrest/cache:/cache"
            # "${pathConfig.appConfig.root}/backrest/tmp:/tmp"
            # "${pathConfig.appConfig.root}/backrest/data:/userdata"
            # "${pathConfig.appConfig.root}/backrest/repos:/repos"
          ];
          labels = [
            "traefik.enable=true"
            "traefik.http.routers.backrest.rule=Host'(`backrest.${fqdn}`)'"
            "traefik.http.services.backrest.loadbalancer.server.port=9898"
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
    9898
  ];
}
