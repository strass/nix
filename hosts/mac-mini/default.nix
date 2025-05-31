{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/stylix.nix
    ../../modules/home-manager.nix
    ../../modules/nix.nix
    ../../modules/ssh.nix
  ];

  system.primaryUser = "zakstrassberg";
  home-manager.users.zakstrassberg.home = {
    homeDirectory = "/Users/${config.system.primaryUser}";
    packages = with pkgs; [
      moonlight-qt
      # steam
    ];
  };

  networking.hostName = "mac-mini";
  networking.wakeOnLan.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
  '';
  nix.linux-builder.enable = true;

  users.users."${config.system.primaryUser}" = {
    description = "zak";
    name = config.system.primaryUser;
    home = "/Users/${config.system.primaryUser}";
    shell = pkgs.fish;
  };
  environment.systemPackages = with pkgs; [
    alejandra
    git
    sqlite
    just
  ];

  programs.fish.enable = true;
  programs.nix-index.enable = true;

  ids.gids.nixbld = 30000; # because my nix version was out of date

  system.stateVersion = 6;
}
