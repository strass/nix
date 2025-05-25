{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: {
  networking.hostName = "mac-mini";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
  '';
  programs.nix-index.enable = true;
  users.users.strass = {
    description = "zak";
    name = "strass";
    shell = pkgs.fish;
  };
  environment.systemPackages = with pkgs; [
    alejandra
    git
    neovim
    sqlite
    just
    eza
    bat
  ];
  programs.fish.enable = true;
  ids.gids.nixbld = 30000; # because my nix version was out of date

  system.stateVersion = 6;
}
