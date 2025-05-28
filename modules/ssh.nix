{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config.services = mkIf cfg.enable {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        UseDns = true;
      };
    };
  };
  config.networking = mkIf cfg.enable {
    firewall.allowedTCPPorts = [22];
  };

  # TODO: grab from config/known-hosts.nix (only if publicKey is listed)
  # TODO: easy way to nixos-anywhere one of these hosts without having to comment out the host that will be remade
  config.programs.ssh.knownHosts = {
    framework = {
      hostNames = ["192.168.1.71" "framework.local" "framework"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyrhHvlLOPJ1UF7r5QgytPa9GHwObXXkQdH/VAJXB4+";
    };
    # gamer = {
    #   hostNames = ["192.168.1.123" "gamer.local" "gamer"];
    #   publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG/pdJKfHUsHVD04Fx87BwCyHeBg5Z57AjLUxT4rTh2 strass@gamer";
    # };
    router = {
      hostNames = ["192.168.1.92" "router.local" "router"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlrsIvuSBHfQakJTUELXUZbXasCpa8CS1KD9czSTKMW strass@nixos";
    };
  };
}
