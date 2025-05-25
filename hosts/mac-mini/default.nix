{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: {
  imports = [
    ../../modules/stylix.nix
  ];

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
  users.users.strass = {
    description = "zak";
    name = "strass";
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
  users.users.zakstrassberg.home = "/Users/zakstrassberg";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;
  home-manager.users.zakstrassberg = {
    # this is internal compatibility configuration
    # for home-manager, don't change this!
    home.stateVersion = "25.05";
    # Let home-manager install and manage itself.
    programs.home-manager.enable = true;
    home.packages = with pkgs; [neovim eza bat xcp dust glances];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs = {
      git = {
        enable = true;
        userName = "Zak Strassberg";
        userEmail = "zakstrassberg@gmail.com";
        ignores = [".DS_Store"];
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
        # url = {
        #   "https://github.com/" = {
        #     insteadOf = [
        #       "gh:"
        #       "github:"
        #     ];
        #   };
        # };
      };
      fish = {
        enable = true;

        shellAliases = {
          ls = "eza";
          top = "glances";
          cat = "bat";
          cp = "xcp";
          # rm = "rip";
          du = "dust";
          vi = "nvim";
          vim = "nvim";
        };
      };
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
  };

  system.stateVersion = 6;
}
