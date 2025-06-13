{
  pkgs,
  fqdn,
  pathConfig,
  ...
}: let
  port = 5000;
  name = "nix-cache";

  mkTraefikService = import ../util/mkTraefikService.nix;
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/home/strass/.ssh/nix-store.secret"; # public: nix-cache.router.local:FdMJI11DQtnf3jk18u/jDj0kOySK1CbjKACQlt3gtZk=
    port = port;
    openFirewall = true;
  };

  services.traefik.dynamicConfigOptions = mkTraefikService {
    name = name;
    fqdn = fqdn;
    port = port;
  };
}
