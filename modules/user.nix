# Assumes a single-user setup
{
  config,
  pkgs,
  lib,
  options,
  ...
}:
with lib; {
  config = {
    users.users.strass = {
      name = "strass";
      description = "zak";
      extraGroups = ["networkmanager" "wheel" "input" "audio" "video" "storage"];
      isNormalUser = true;
      uid = 1000;
    };

    users.groups.strass = {};

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    hm.home.username = "strass";
    hm.home.homeDirectory = "/home/strass";

    nix.settings = let
      users = ["root" "strass"];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    users.users.root = {
      packages = [pkgs.shadow];
      shell = pkgs.shadow;
      # hashedPassword = "!";
    };
  };
}
