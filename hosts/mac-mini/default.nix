{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/stylix.nix
    ../../modules/home-manager.nix
  ];

  hm.home.homeDirectory = "/Users/zakstrassberg";

  networking.hostName = "mac-mini";
  networking.wakeOnLan.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
  '';
  nix.linux-builder.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.nix-index.enable = true;
  system.primaryUser = "zakstrassberg";
  users.users.zakstrassberg = {
    description = "zak";
    name = "zakstrassberg";
    home = "/Users/zakstrassberg";
    shell = pkgs.fish;
  };
  environment.systemPackages = with pkgs; [
    alejandra
    git
    sqlite
    just
  ];
  programs.fish = {
    enable = true;
  };

  # https://davi.sh/blog/2024/11/nix-vscode/
  # programs.vscode = {
  #   enable = true;
  # };

  ids.gids.nixbld = 30000; # because my nix version was out of date

  system.stateVersion = 6;
}
