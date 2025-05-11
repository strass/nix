{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    636
  ];

  services = {
    resolved = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      reflector = true;
      publish = {
        enable = true;
        workstation = true;
        userServices = true;
        addresses = true;
        hinfo = true;
        domain = true;
      };
      browseDomains = ["framework.local"];
    };
  };
}
