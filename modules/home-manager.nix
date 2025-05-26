{inputs, ...}: let
  inherit (builtins) toString;
  inherit (lib.modules) mkAliasOptionModule mkDefault mkIf;
  # inherit (lib.my) mapModulesRec';
in {
  imports = [
    #inputs.hyprland.homeManagerModules.default
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule ["hm"] ["home-manager" "users" "strass"]) # used to be ["home-manager" "users" config.user.name]
  ];

  home-manager.backupFileExtension = "hm-backup";
  hm.home.stateVersion = config.system.stateVersion;
  hm.home.enableNixpkgsReleaseCheck = false;
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

  home-manager.users.strass = {
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

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;

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
