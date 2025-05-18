{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
      ];
    };
    graphics.enable = true;
    graphics.extraPackages = with pkgs; [vaapiIntel intel-media-driver];

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

      # prime = {
      #   # Make sure to use the correct Bus ID values for your system!
      #   intelBusId = "PCI:0:2:0";
      #   nvidiaBusId = "PCI:14:0:0";
      #   # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
      # };
    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    mosh = {enable = true;};
    gamescope.enable = true;
    gamescope.capSysNice = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      extraPackages = with pkgs; [
        mangohud
        gamescope-wsi
      ];

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
  };

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    ENABLE_HDR_WSI = "1";
    DXVK_HDR = "1";
    PROTON_ENABLE_AMD_AGS = "1";
    PROTON_ENABLE_NVAPI = "1";
    ENABLE_GAMESCOPE_WSI = "1";
    STEAM_MULTIPLE_XWAYLANDS = "1";
  };
}
