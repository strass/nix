{ config, lib, ... }:

with lib;
let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        UseDns = true;
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}