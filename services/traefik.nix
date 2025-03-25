{config, ...}: {
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      # providers.docker.endpoint = "unix:///tmp/podman.sock"; # docker/podman not working
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

    # group = "podman";

    dynamicConfigOptions = {
      http.routers = {};
      http.services = {};
    };
  };

  networking.firewall.allowedTCPPorts = [
    8080
    80
    443
  ];
}
