{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.modules) mkAliasOptionModule mkDefault mkIf;
  # inherit (lib.my) mapModulesRec';
in {
  imports = [
    # inputs.nix-colors.homeManagerModules.default
    #inputs.hyprland.nixosModules.default
    #inputs.lix-module.nixosModules.default

    # Load my modules
    ../services/avahi.nix # everyone loads avahi
    ./locale.nix
    ./sound.nix
    ./ssh.nix
    ./home-manager.nix
    ./nix.nix
    ./distributed-builds.nix
  ];

  # Linux only (so not in home-manager config)
  home-manager.users.strass = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
    # This is crucial to ensure the systemd services are (re)started on config change
    systemd.user.startServices = "sd-switch";
  };

  system = {
    stateVersion = "25.05";
    configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  };

  # boot = {
  #   kernelPackages = mkDefault pkgs.unstable.linuxPackages_latest;
  #   kernelParams = ["pcie_aspm.policy=performance"];
  # };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
    unrar
    unzip
    micro
    curl
    wget
    desktop-file-utils
    shared-mime-info
    xdg-user-dirs
    xdg-utils
    fish
    git
    fuzzel
    firefox
    cog
    zoxide
    eza
    glances
    bat
    xcp
    rm-improved
    dysk
    dust
    neovim
    direnv
    sqlite
    just
    alejandra
  ];

  # if I mkDefault this then it conflicts with the nano default from nixos
  environment.variables.EDITOR = "nvim";

  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/";
}
