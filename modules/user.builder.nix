# Assumes a single-user setup
{
  config,
  pkgs,
  lib,
  options,
  inputs,
  ...
}: let
  hosts = import ../config/known-hosts.nix;
in {
  users.users.builder = {
    name = "builder";
    group = "builder";
    description = "builder";
    shell = pkgs.fish;
    isSystemUser = true;
    # Builder can be accessed by any of my known hosts
    openssh.authorizedKeys.keys = hosts.authorizedKeys;
  };
  users.groups.builder = {};
}
