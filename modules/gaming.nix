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
    gamescope.capSysNice = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      extraPackages = with pkgs; [
        mangohud
        gamescope-wsi
      ];
    };
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
