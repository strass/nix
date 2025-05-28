{
  config,
  pkgs,
  ...
}: {
  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "framework.local";
      sshUser = "strass";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
    {
      hostName = "gamer.local";
      sshUser = "strass";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
