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
        PasswordAuthentication = false;
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
    gamer-edc-strass = {
      hostNames = ["192.168.1.123" "gamer.local" "gamer"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM5BreWIM2ffeI9+evDQECrEOPPwZ5qKwTq+WwGb2mJ";
    };
    gamer-rsa-root = {
      hostNames = ["192.168.1.123" "gamer.local" "gamer"];
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8OyPDvEgUYHbouf1pxiz1T5U9y/AE/G5pJQKz9RAcagjLa7zrHFTGHbm6B2LEmCIoS4PWUdhO03q8boTGqqQp4DGA/3Da8hKQJmkZf0tGYmte+8E3gphwHGYOm8kSI201jfX8M7fy+XXpc+Ib3OTfsFx37iwLaZ0pn83MAnBr3MpuIWnHZ6FYJzIUsbE8a8+dZtTFfk6EaebVbnoP9lwKgyRWOz3s323A6239WZ6GO85meDLkJqD/CZMFPgbQhgmL3FoyNy2sOJL7305dqWRGlvPd+ojea5cirJgQ/Yu8Qz39bj+fnnpLjES5+0kTJl5quModPHVa/nafi2yHmH60urpbVwCX4RRBphGXrASAMfNirZlCdMCjfl/H+Dh83PEXl6SZg95fsF2P4po1Fkr9Gd4r6UVXtRqK0QZdymcjDI84AdGnb/PYZP8HW1JACXnhPREOOW2W/t41GAytH6qDR/yKMMaqUGx1lEZ62aSAMhEsoQUoJfx4gri1TNwuAfugLkkp9m/l+j7YIBaBNtl3SnvpbbWbToXzAfTRErRMTwgegk4fjpOQ2xeBUR3/i5AjolxzsoSihYIC3RuTgRrD20DpMlWJknQI+FTSBQatC/vMHj6mQEY1/0VfD7iDVcRaWV8wSVJcFVvC+hOXUBli1edaPr0M5htuBMpuFPuYvQ==";
    };
  };
}
