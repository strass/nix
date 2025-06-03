{
  lib,
  inputs,
  pkgs,
  ...
}: {
  # documentation.nixos.enable = lib.mkDefault false;

  nix = {
    package = pkgs.nixVersions.stable;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

    optimise = {
      automatic = true;
      dates = ["03:45"];
      # interval = {
      #   Hour = 3;
      #   Minute = 15;
      # };
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # interval = {
      #   Weekday = 0;
      #   Hour = 0;
      #   Minute = 0;
      # };
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      # Would complicates copying between hosts.
      # FIXME: Yes this is a security issue
      require-sigs = false;
      # Don't stop debugger on caught exceptions
      ignore-try = true;
      # If you're not receiving anything for 20s, just retry
      stalled-download-timeout = 20;
      # I do not care.
      warn-dirty = false;
      # Builders should substitute from cache.nixos.org
      builders-use-substitutes = true;
    };

    # daemonCPUSchedPolicy = "batch";
    # daemonIOSchedClass = "idle";
    # # maybe set to batch on non-desktop
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  programs.command-not-found.dbPath = "/nix/var/nix/programs.sqlite";

  # programs.nh = {
  #   enable = true;
  #   clean.enable = true;
  #   clean.extraArgs = "--keep-since 10d --keep 5";
  #   flake = "github:strass/nix"; # not allowed
  # };
}
