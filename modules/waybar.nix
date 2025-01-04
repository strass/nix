{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.modules.desktop.waybar;
in {
  options.modules.desktop.execOnStart = mkOption {
      type = types.listOf types.str;
      description = "Commands to call upon startup";
      default = null;
    };
  options.modules.desktop.waybar = {
    enable = mkEnableOption "Enable Waybar, a highly customizable Wayland bar";
    package = mkOption {
      type = types.package;
      default = inputs.waybar.packages."x86_64-linux".default;
      example = "pkgs.waybar";
    };
    hostname = mkOption {
      description = "Hostname name, for the iterator icon";
      type = types.nullOr types.str;
      default = null;
    };
    style = mkOption {
      description = "Content of the CSS style file";
      type = types.str;
      default = "";
    };
    styleTop = mkOption {
      description = "CSS to add at the top, like import statements";
      type = types.str;
      default = "";
    };
    fontSize = mkOption {
      description = "Temporary option while I figure out what's wrong with the GTK font handling";
      type = types.number;
      default = 12;
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.execOnStart = [ "${lib.getExe cfg.package}" ];
    hm.programs.waybar = {
      enable = true;
      package = cfg.package;
      style = builtins.concatStringsSep "\n" [
        cfg.styleTop
        "window, tooltip, window.popup menu {\n  font-size: ${toString cfg.fontSize}px;\n}"
        cfg.style
      ];
      settings = let
        window = {
          format = "{}";
          icon = true;
          max-length = 96;
          icon-size = 16;
          rewrite = {
            "(.*) - Vivaldi" = "$1";
            "(.*) - Visual Studio Code" = "$1";
            #"(.*\\.nix\\s.*)" = "";
            "(\\S+\\.js\\s.*)" = " $1";
            "(\\S+\\.ts\\s.*)" = " $1";
            "(\\S+\\.go\\s.*)" = " $1";
            "(\\S+\\.lua\\s.*)" = " $1";
            "(\\S+\\.java\\s.*)" = " $1";
            "(\\S+\\.rb\\s.*)" = " $1";
            "(\\S+\\.php\\s.*)" = " $1";
            "(\\S+\\.jsonc?\\s.*)" = " $1";
            "(\\S+\\.md\\s.*)" = " $1";
            "(\\S+\\.txt\\s.*)" = " $1";
            "(\\S+\\.cs\\s.*)" = " $1";
            "(\\S+\\.c\\s.*)" = " $1";
            "(\\S+\\.cpp\\s.*)" = " $1";
            "(\\S+\\.hs\\s.*)" = " $1";
            ".*Discord | (.*) | .*" = "$1";
            #"(.*) - ArmCord" = "$1";
          };
          separate-outputs = true;
        };
        workspaces = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            urgent = "";
            default = "•";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
        };
      in {
        mainBar = {
          layer = "top";
          position = "top";
          #spacing = 4;
          height = 28;
          margin-top = 6;
          margin-left = 6;
          margin-right = 6;
          margin-bottom = 0;
          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
          ];

    
          "niri/workspaces" = workspaces;
          "niri/window" = window;
          
        };
      };
    };
  };
} 