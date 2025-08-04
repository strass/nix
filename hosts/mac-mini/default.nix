{
  config,
  pkgs,
  lib,
  ...
}: let
  hosts = import ../../config/known-hosts.nix;
in {
  imports = [
    ../../modules/stylix.nix
    ../../modules/home-manager.nix
    # ../../modules/nix.nix
    # ../../modules/fonts.nix
  ];

  system.primaryUser = "zakstrassberg";
  home-manager.users.zakstrassberg.home = {
    packages = with pkgs; [
      moonlight-qt
      # steam
    ];
  };
  home-manager.users.zakstrassberg.programs.starship.settings.hostname = {
    ssh_only = false;
    ssh_symbol = "🍏 ";
  };

  networking.hostName = "mac-mini";
  networking.wakeOnLan.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
  '';
  nix.linux-builder.enable = true;

  users.users."${config.system.primaryUser}" = {
    description = "zak";
    name = config.system.primaryUser;
    home = "/Users/${config.system.primaryUser}";
  };

  environment.systemPackages = with pkgs; [
    alejandra
    git
    sqlite
    just
  ];

  programs.fish.enable = true;
  programs.nix-index.enable = true;
  # programs.ssh.knownHosts = builtins.attrValues (hosts.knownHosts);

  ids.gids.nixbld = 30000; # because my nix version was out of date
  system.stateVersion = 6;
}
