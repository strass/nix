{
  self,
  config,
  lib,
  pkgs,
  fqdn,
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
      # hostName = config.networking.hostName;
      # domainName = fqdn;
      nssmdns4 = true;
      openFirewall = true;
      # reflector = true;
      publish = {
        enable = true;
        workstation = true;
        userServices = true;
        addresses = true;
        hinfo = true;
        domain = true;
      };
      extraServiceFiles = {
        ssh = lib.mkIf config.services.openssh.enable "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
    };
  };
}
