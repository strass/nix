{
  pkgs,
  fqdn,
  pathConfig,
  ...
}: let
  port = 8000;
  name = "restic";

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.restic.server = {
    enable = true;
    extraFlags = ["--no-auth"];
    privateRepos = true;
    # listenAddress = toString port;
    dataDir = pathConfig.backup.restic;
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
