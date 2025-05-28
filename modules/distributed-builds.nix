{
  config,
  pkgs,
  system,
  ...
}: let
  # TODO: pull from config/known-hosts.nix
  buildMachines = [
    {
      hostName = "framework";
      sshUser = "strass";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
    {
      hostName = "gamer";
      sshUser = "strass";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];
in {
  nix.distributedBuilds = true;

  nix.buildMachines = builtins.filter ({hostName, ...}: hostName != config.networking.hostName) buildMachines;

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
