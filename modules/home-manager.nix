{
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule mkDefault;
  primaryUser = config.system.primaryUser or config.user.name or "strass"; # should the default be nixos?
in {
  imports = [
    (mkAliasOptionModule ["hm"] ["home-manager" "users" primaryUser])
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = "hm-backup";

  hm = {
    home = {
      username = primaryUser;
      homeDirectory = mkDefault "/home/${primaryUser}";
      packages = with pkgs; [
        neovim
        eza
        bat
        xcp
        dust
        glances
        # pkgs-unstable.ghostty # marked as broken
      ];
      sessionVariables = {
        EDITOR = "nvim";
      };

      enableNixpkgsReleaseCheck = false;
      stateVersion = "25.05";
    };

    programs = {
      home-manager.enable = true;
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
}
