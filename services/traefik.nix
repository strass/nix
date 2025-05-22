{
  config,
  fqdn,
  ...
}: let
  name = "traefik";
  port = 8080;

  mkTraefikService = import ../util/mkTraefikService.nix;
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

    # dynamicConfigOptions = {
    #   http.routers = {};
    #   http.services = {};
    # };
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };

  networking.firewall.allowedTCPPorts = [
    port
    80
    443
  ];
}
