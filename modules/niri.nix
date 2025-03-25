{
  lib,
  config,
  pkgs,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.modules.desktop.niri;
in {
  options.modules.desktop.niri = {
    enable = mkEnableOption "Enable niri, a scrollable-tiling Wayland compositor.";
    package = mkOption {
      type = types.package;
      default = pkgs.niri-unstable;
      example = "pkgs.niri";
    };
  };
  options.modules.desktop.execOnStart = mkOption {
    type = types.listOf types.str;
    description = "Commands to call upon startup";
    default = null;
  };

  imports = [
    inputs.niri.nixosModules.niri
  ];

  config = mkIf cfg.enable {
    hm.home.packages = [
      pkgs.xwayland-satellite-unstable
      # inputs.swww.packages.${pkgs.system}.swww
      # pkgs.hyprlock
      # pkgs.wleave
      # pkgs.gammastep
    ];
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
      enable = true;
      package = cfg.package;
    };
    systemd.user.services.niri-flake-polkit.enable = false;
    hm.programs.niri = {
      settings = {
        spawn-at-startup =
          [
            {command = ["${lib.getExe pkgs.xwayland-satellite-unstable}"];}
            {command = ["${pkgs.deepin.dde-polkit-agent}/lib/polkit-1-dde/dde-polkit-agent"];} # authentication prompts
            {command = ["${lib.getExe pkgs.wl-clip-persist} --clipboard primary"];} # to fix wl clipboards disappearing
          ]
          ++ (map (cmd: {command = ["sh" "-c" cmd];}) config.modules.desktop.execOnStart);

        # https://github.com/YaLTeR/niri/wiki/Configuration:-Input
        input = {
          #workspace-auto-back-and-forth = true;

          keyboard.xkb = {
            layout = "us";
            variant = "";
            options = "grp:win_space_toggle";
          };

          touchpad = {
            tap = true;
            natural-scroll = true;
            #dwt = true;
          };
          # mouse = {
          #   off = true;
          # };
          # trackpoint = {
          #   off = true;
          # };
        };

        outputs."HDMI-A-2" = {
          # mode = "1920x720";
          # scale = 1.5;
          transform.rotation = 90;
        };

        environment = {
          DISPLAY = ":0";
        };

        prefer-no-csd = true;

        # https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
        layout = {
          gaps = 16;

          center-focused-column = "always";
          preset-column-widths = [
            # { proportion = 1. / 1. ; }

            # { fixed = 1920; }
          ];
          default-column-width = {};
          focus-ring = {
            enable = false;
            width = 1;
            # active.color = config.modules.desktop.themes.niri.accent;
            # inactive.color = config.modules.desktop.themes.niri.inactive;
          };

          border = {
            enable = true;
            width = 1;
            # active.color = config.modules.desktop.themes.niri.accent;
            # inactive.color = config.modules.desktop.themes.niri.inactive;
          };
          struts = {
            left = 16;
            right = 16;
            top = -16;
            bottom = -16;
          };
        };
        hotkey-overlay.skip-at-startup = true;

        screenshot-path = null;

        # workspaces = {
        #   web = {};
        #   discord = {};
        # };

        # https://github.com/YaLTeR/niri/wiki/Configuration:-Animations
        animations = {
          shaders.window-resize = ''
            vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
              vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

              vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
              vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

              // We can crop if the current window size is smaller than the next window
              // size. One way to tell is by comparing to 1.0 the X and Y scaling
              // coefficients in the current-to-next transformation matrix.
              bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
              bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

              vec3 coords = coords_stretch;
              if (can_crop_by_x)
                coords.x = coords_crop.x;
              if (can_crop_by_y)
                coords.y = coords_crop.y;

              vec4 color = texture2D(niri_tex_next, coords.st);

              // However, when we crop, we also want to crop out anything outside the
              // current geometry. This is because the area of the shader is unspecified
              // and usually bigger than the current geometry, so if we don't fill pixels
              // outside with transparency, the texture will leak out.
              //
              // When stretching, this is not an issue because the area outside will
              // correspond to client-side decoration shadows, which are already supposed
              // to be outside.
              if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                color = vec4(0.0);
              if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                color = vec4(0.0);

              return color;
            }
          '';

          window-close = {
            easing = {
              curve = "linear";
              duration-ms = 600;
            };
          };
          shaders.window-close = ''
            vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) {
              float progress = niri_clamped_progress * niri_clamped_progress;
              vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;
              coords.y -= progress * 1440.0;
              float random = (niri_random_seed - 0.5) / 2.0;
              random = sign(random) - random;
              float max_angle = 0.5 * random;
              float angle = progress * max_angle;
              mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
              coords = rotate * coords;
              coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);
              vec3 coords_tex = niri_geo_to_tex * coords_geo;
              vec4 color = texture2D(niri_tex, coords_tex.st);

              return color;
            }

            vec4 close_color(vec3 coords_geo, vec3 size_geo) {
              return fall_and_rotate(coords_geo, size_geo);
            }
          '';
        };

        # https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules
        window-rules = [
          {
            matches = [{app-id = "^org\.wezfurlong\.wezterm$";}];
            default-column-width = {};
          }
          (let
            allCorners = r: {
              bottom-left = r;
              bottom-right = r;
              top-left = r;
              top-right = r;
            };
          in {
            geometry-corner-radius = allCorners 10.0;
            clip-to-geometry = true;
          })
          {
            matches = [
              {app-id = "^clipse$";}
              {app-id = "^dde-polkit-agent$";}
              #{ app-id = "^rofi-rbw$"; }
            ];
            block-out-from = "screen-capture";
            focus-ring = {
              # fog of war type effect
              enable = true;
              width = 4000;
              active.color = "#00000065";
              inactive.color = "#00000065";
            };
          }
          {
            matches = [{app-id = "Discord";}];
            open-on-workspace = "discord";
          }
        ];

        # https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings
        binds = with config.hm.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+D".action = spawn "fuzzel";

          "Mod+Q".action = close-window;
          "Mod+Shift+Q".action = quit;

          "Mod+Left".action = focus-column-left;
          "Mod+Down".action = focus-window-down;
          "Mod+Up".action = focus-window-up;
          "Mod+Right".action = focus-column-right;
          "Mod+F".action = maximize-column;
        };
      };
    };
  };
}
