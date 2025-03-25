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
      extraGroups = ["networkmanager" "wheel" "input" "audio" "video" "storage"];
      isNormalUser = true;
      uid = 1000;
      # required for auto start before user login
      linger = true;
      # required for rootless container with multiple users
      autoSubUidGidRange = true;
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
