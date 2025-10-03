{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    mosh = {enable = true;};
    gamescope = {
      enable = true;
      capSysNice = true;
      env = {
        # SDL_VIDEODRIVER = "x11";
      };
      args = [
        "-h 1080"
        "-w 1920"
        "-H 1080"
        "-W 1920"
        # "--adaptive-sync"
      ];
    };
    gamemode = {
      enable = true;
      # enableRenice = true;
      # settings = {
      #   general = {
      #     renice = 10;
      #     reaper_freq = 5;
      #     desiredgov = "performance";
      #     igpu_desiredgov = "powersave";
      #     igpu_power_threshold = 0.3;
      #   };
      #   custom = {
      #     start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
      #     end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      #   };
    };
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      # extraPackages = with pkgs; [
      #   mangohud
      #   gamescope-wsi
      #   gamemode
      #   libkrb5
      #   keyutils
      # ];

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    # vkbasalt
    # scopebuddy

    # pkgs.heroic
    # pkgs.bottles
    # dolphin-emu
  ];

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    # ENABLE_HDR_WSI = "1";
    # DXVK_HDR = "1";
    PROTON_ENABLE_AMD_AGS = "1";
    PROTON_ENABLE_NVAPI = "1";
    ENABLE_GAMESCOPE_WSI = "1";
    STEAM_MULTIPLE_XWAYLANDS = "1";
  };
}
