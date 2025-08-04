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
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users."${primaryUser}" = {
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
      shell.enableFishIntegration = true;
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
          url."https://github.com/".insteadOf = "gh:";
          url."https://github.com/strass/".insteadOf = "strass:";
        };
      };
      fish = {
        enable = true;

        shellAliases = {
          ls = "eza";
          top = "glances";
          cat = "bat";
          cp = "xcp";
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
        colors = "auto";
        extraOptions = ["--icons=auto"];
        git = true;
      };
      television = {
        enable = true;
        enableFishIntegration = true;
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
      # disable on darwin
      ghostty = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
