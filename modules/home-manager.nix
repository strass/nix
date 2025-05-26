{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.modules) mkAliasOptionModule mkDefault mkIf;
  # inherit (lib.my) mapModulesRec';
in {
  imports = [
    (mkAliasOptionModule ["hm"] ["home-manager" "users" config.system.primaryUser]) # used to be ["home-manager" "users" config.user.name]
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  home-manager.backupFileExtension = "hm-backup";
  programs.fish.enable = true;

  hm = {
    home = {
      username = config.system.primaryUser;
      homeDirectory = mkDefault "/home/${config.system.primaryUser}";
      packages = with pkgs; [neovim eza bat xcp dust glances];
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
