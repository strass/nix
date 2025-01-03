# Assumes a single-user setup

{ config, pkgs, lib, options, ... }:

with lib;
{
  options = {
    user = mkOption types.attrs {};
  };

  config = {
    user = rec {
      name = "strass";
      description = "zak";
      extraGroups = ["networkmanager" "wheel" "input" "audio" "video" "storage"];
      isNormalUser = true;
      home = "/home/${name}";
      group = name;
      uid = 1000;
    };
    users.groups.${config.user.group} = {};

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    hm.home.username = config.user.name;
    hm.home.homeDirectory = lib.mkForce config.user.home;

    nix.settings = let
      users = ["root" config.user.name];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    users.users.root = {
      packages = [ pkgs.shadow ];
      shell = pkgs.shadow;
      # hashedPassword = "!";
    };
  };
}