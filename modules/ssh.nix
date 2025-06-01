{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ssh;

  hosts = import ../config/known-hosts.nix;
in {
  options.modules.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config.services = mkIf cfg.enable {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        UseDns = true;
      };
    };
  };
  config.networking = mkIf cfg.enable {
    firewall.allowedTCPPorts = [22];
  };

  # TODO: easy way to nixos-anywhere one of these hosts without having to comment out the host that will be remade
  config.programs.ssh.knownHosts = hosts.knownHosts;
  # config.programs.ssh.startAgent = true;
}
