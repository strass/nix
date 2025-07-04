{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # ensure you use the same package in hm and nixos
  niri = pkgs.niri-unstable;

  # autologin on tty7y. Otherwise autologin and getty alternate in grabbing tty1 on nixos-rebuild switch
  autologin_on_7 = pkgs.autologin.overrideAttrs (
    _: {
      postPatch = ''
        substituteInPlace "main.c" \
          --replace-fail "setup_vt(1);" "setup_vt(7);" \
          --replace-fail "XDG_VTNR=1" "XDG_VTNR=7"
      '';
    }
  );
in {
  services.xserver = {
    enable = true;
    # desktopManager.gnome.enable = true;
    # displayManager = {
    #   gdm = {
    #     enable = true;
    #     wayland = lib.mkDefault true;
    #     autoSuspend = lib.mkDefault false;
    #   };
    # };
  };
  # programs.dconf.enable = true;
  services.displayManager.defaultSession = "niri";
  # qt wayland: https://discourse.nixos.org/t/problem-with-qt-apps-styling/29450/8
  qt.platformTheme = "qt5ct";
  systemd.user.services.xwayland-satellite.wantedBy = ["graphical-session.target"];

  xdg.portal = {
    enable = true;
    lxqt = {
      enable = true;
      styles = [pkgs.libsForQt5.qtstyleplugin-kvantum];
    };
  };

  # use the overlay
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  # enable niri in nixos
  programs.niri = {
    enable = true;
    package = niri;
  };

  # enable and configure niri in hm
  home-manager.users.strass = {config, ...}: {
    # imports = [
    #   inputs.niri.homeModules.config
    #   inputs.niri.homeModules.stylix # optional: stylix integration
    # ];
    programs.niri = {
      package = niri;
      settings = {
        environment = {
          NIXOS_OZONE_WL = "1"; # support electron and chromium based apps
          DISPLAY = ":0"; # important for xwayland-satellite
          # QT_QPA_PLATFORM = "wayland"; # optional: force QT apps to always use wayland
        };
        spawn-at-startup = [
          {command = ["xwayland-satellite"];}
        ];
        # use niri actions
        binds = with config.lib.niri.actions; {
          # example binding to a niri action
          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Right".action = move-column-right;
          # example binding to a custom command
          "Mod+H".action.spawn = [
            "firefox"
            "https://github.com/YaLTeR/niri/wiki/Getting-Started"
            "https://github.com/sodiboo/niri-flake"
            "https://github.com/sodiboo/niri-flake/blob/main/docs.md"
          ];
        };
        # hotkey-overlay.skip-at-startup = true; # optional: hide the keybinding popup
      };
    };
  };

  # see https://git.sr.ht/~kennylevinsen/autologin
  # TODO https://superuser.com/questions/1904422/how-to-auto-login-without-display-manager-for-nixos-wayland-niri/1904473#1904473
  environment.systemPackages = with pkgs; [
    xwayland-satellite # support legacy x apps
    wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
    autologin_on_7
  ];

  systemd.services.autologin = {
    enable = true;
    restartIfChanged = lib.mkForce false;
    description = "Autologin";
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
    ];

    serviceConfig = {
      ExecStart = "${autologin_on_7}/bin/autologin thk ${niri}/bin/niri-session";
      Type = "simple";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      Restart = "always";
      RestartSec = "10";
    };
    startLimitBurst = 5;
    startLimitIntervalSec = 30;
    aliases = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
  };

  security.pam.services.autologin = {
    enable = true;
    name = "autologin";
    startSession = true;
    setLoginUid = true;
    updateWtmp = true;
  };
}
