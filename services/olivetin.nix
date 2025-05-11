{
  inputs,
  pkgs,
  ...
}: let
  name = "olivetin";
  port = 8200;
in {
  services.olivetin = {
    package = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}".olivetin;

    enable = true;
    settings = {
      ListenAddressSingleHTTPFrontend = "0.0.0.0:${toString port}";
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
