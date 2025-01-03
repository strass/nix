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
    users.users.strass  =  {
      name = "strass";
      description = "zak";
      extraGroups = ["networkmanager" "wheel" "input" "audio" "video" "storage"];
      isNormalUser = true;
      home = "/home/strass";
      group = "strass";
      uid = 1000;
    };

      #  users.groups.strass = {};

    # users.users.${config.user.name} = mkAliasDefinitions options.user;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    # # hm.home.username = config.user.name;
    # hm.home.homeDirectory = lib.mkForce config.user.home;

    # nix.settings = let
    #   users = ["root" config.user.name];
    # in {
    #   trusted-users = users;
    #   allowed-users = users;
    # };

    # users.users.root = {
    #   packages = [ pkgs.shadow ];
    #   shell = pkgs.shadow;
    #   # hashedPassword = "!";
    # };
  };
}
