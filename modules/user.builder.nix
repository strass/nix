# Assumes a single-user setup
{
  config,
  pkgs,
  lib,
  options,
  inputs,
  ...
}: {
  users.users.builder = {
    name = "builder";
    description = "builder";
    shell = pkgs.fish;
    isSystemUser = true;
    # openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
  };
  users.users.groups.builder = {};
}
