{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../services/gaming.sunshine.nix
  ];

  hardware = {
    graphics = {
      enable = true;
      # enable32Bit = true;
      # driSupport = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
        libva
        vkbasalt
      ];
    };

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      # NOTE: I have a 1080 in here so this is set to false.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    steam-hardware.enable = true;
    xpadneo.enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
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
