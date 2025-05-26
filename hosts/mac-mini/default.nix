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

  system.primaryUser = "zakstrassberg";
  hm.home.homeDirectory = "/Users/${config.system.primaryUser}";

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
    home = hm.home.homeDirectory;
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

  # https://davi.sh/blog/2024/11/nix-vscode/
  # programs.vscode = {
  #   enable = true;
  # };

  ids.gids.nixbld = 30000; # because my nix version was out of date

  system.stateVersion = 6;
}
