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
    settings.experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;
    environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}
