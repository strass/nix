{
  config,
  fqdn,
  ...
}: let
  name = "traefik";
  port = 8080;
in {
  services.traefik = {
    enable = true;
    group = "podman";

    staticConfigOptions = {
      providers.docker = {
        endpoint = "unix:///var/run/podman/podman.sock";
        allowEmptyServices = true;
      };
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          # http.redirections.entrypoint = {
          #   to = "websecure";
          #   scheme = "https";
          # };
        };

        # websecure = {
        #   address = ":443";
        #   asDefault = true;
        #   http.tls.certResolver = "letsencrypt";
        # };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      # certificatesResolvers.letsencrypt.acme = {
      #   email = "postmaster@YOUR.DOMAIN";
      #   storage = "${config.services.traefik.dataDir}/acme.json";
      #   httpChallenge.entryPoint = "web";
      # };

      api.dashboard = true;
      api.insecure = true;
    };

    dynamicConfigOptions = {
      http.routers = {};
      http.services = {};
    };
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

  networking.firewall.allowedTCPPorts = [
    8080
    80
    443
  ];
}
