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

      openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
    };
    users.groups.strass = {};

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.strass = {
      pkgs,
      config,
      ...
    }: {
      imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
      # This is crucial to ensure the systemd services are (re)started on config change
      systemd.user.startServices = "sd-switch";
    };
    programs.fish.enable = true;
    hm.home = {
      username = "strass";
      homeDirectory = "/home/strass";
      shellAliases = {
        #        cd = "zoxide";
        ls = "eza";
        top = "glances";
        cat = "bat";
        cp = "xcp";
        rm = "rip";
        du = "dust";
        vi = "nvim";
        vim = "nvim";
      };
    };

    hm.programs = {
      fish.enable = true;
      atuin = {
        enable = true;
        enableFishIntegration = true;
      };
      autojump = {
        enable = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
      };
      eza = {
        enable = true;
        enableFishIntegration = true;
      };
    };

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
