{
  nixpkgs.config.allowUnfree = true; # Plex is unfree

  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "plex";
    group = "plex";

    managePlugins = true;
    extraPlugins = [];
  };

  networking.firewall = {
    # allowedTCPPorts = [3005 8324 32469 80 443];
    # allowedUDPPorts = [1900 5353 32410 32412 32413 32414];
  };

  services.traefik.dynamicConfigOptions = {
    http.routers = {};
    http.services = {};
  };
}
