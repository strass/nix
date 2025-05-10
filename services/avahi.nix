{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    548 # netatalk (could be only allowed if netatalk enabled)
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
