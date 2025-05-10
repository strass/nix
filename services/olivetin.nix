{
  inputs,
  pkgs,
  ...
}: {
  services.olivetin = {
    package = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}".olivetin;

    enable = true;
    settings = {
      ListenAddressSingleHTTPFrontend = "0.0.0.0:8200";
      actions = [
        {
          id = "hello_world";
          title = "Say Hello";
          shell = "echo -n 'Hello World!' | tee /tmp/result";
        }
      ];
    };
    extraConfigFiles = [
      (builtins.toFile "secrets.yaml" ''
        actions:
          - id: secret
            title: Secret Action
            shell: echo -n secret > /tmp/result2
      '')
    ];
  };

  # networking.firewall = {
  #   allowedTCPPorts = [8200];
  # };

  services.traefik.dynamicConfigOptions = {
    http.routers.olivetin = {
      rule = "Host(`olivetin.framework.local`)";
      service = "olivetin";
    };
    http.services.olivetin = {
      loadBalancer.servers = [
        {
          url = "http://localhost:8200";
        }
      ];
    };
  };
}
