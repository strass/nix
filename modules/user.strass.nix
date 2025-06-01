# Assumes a single-user setup
{
  config,
  pkgs,
  lib,
  options,
  inputs,
  ...
}:
with lib; {
  config = {
    users.mutableUsers = mkDefault false;

    users.users.strass = {
      name = "strass";
      description = "zak";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "audio"
        "video"
        "storage"
        "podman" # is it possible to add conditionally from podman module?
      ];
      isNormalUser = true;
      uid = 1000;
      # required for auto start before user login
      linger = true;
      # required for rootless container with multiple users
      autoSubUidGidRange = true;

      # imports from github profile
      openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
    };
    users.groups.strass = {};
    programs.fish.enable = true;
    programs.fish.promptInit = ''      function fish_greeting
        cat /etc/motd
      end
    '';
    nix.settings = let
      users = ["root" "strass"];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    security.sudo.extraRules = [
      {
        users = ["strass"];
        commands = [
          {
            command = "ALL";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];

    users.users.root = {
      packages = [pkgs.shadow];
      shell = pkgs.shadow;
      # hashedPassword = "!";
    };
  };
}
