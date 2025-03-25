{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    548 # netatalk
    636
  ];

  services = {
    # resolved = {
    #   enable = true;
    # };

    netatalk = {
      enable = false;
    };

    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
      };
    };
  };
}
