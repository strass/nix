{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override {fonts = ["FiraCode" "MPlus"];})
  ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    serif = ["Liberation Serif" "Vazirmatn"];
    sansSerif = ["Ubuntu" "Vazirmatn"];
    monospace = ["Ubuntu Mono"];
  };
  fonts.fontDir.enable = true;
}
