{
  config,
  lib,
  pkgs,
  ...
}: {
  # https://search.nixos.org/packages?channel=25.05&from=0&size=50&sort=relevance&type=packages&query=nerd-fonts
  fonts.packages = with pkgs; [
    # noto-fonts
    # noto-fonts-cjk-sans
    # noto-fonts-emoji
    # liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    # dina-font
    proggyfonts
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.meslo-lg
  ];

  # These need to be disabled on darwin
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    serif = ["Liberation Serif" "Vazirmatn"];
    sansSerif = ["Ubuntu" "Vazirmatn"];
    monospace = ["Ubuntu Mono"];
  };
  fonts.fontDir.enable = true;
}
