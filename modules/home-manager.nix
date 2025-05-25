{}: {
  programs.fish.enable = true;
  hm.home = {
    username = "strass";
    homeDirectory = "/home/strass";
    shellAliases = {
      #        cd = "zoxide";
      ls = "eza";
      top = "glances";
      cat = "bat";
      cp = "xcp";
      rm = "rip";
      du = "dust";
      vi = "nvim";
      vim = "nvim";
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.strass = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
    # This is crucial to ensure the systemd services are (re)started on config change
    systemd.user.startServices = "sd-switch";
  };

  hm.programs = {
    fish.enable = true;
    atuin = {
      enable = true;
      enableFishIntegration = true;
    };
    autojump = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
