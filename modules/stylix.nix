{
  pkgs,
  lib,
  inputs,
  ...
}: let
  wallpapers = {
    rose-pine = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ng-hai/hyper-rose-pine-next/refs/heads/main/wallpaper/dark/wallpaper-block-wave/themer-wallpaper-block-wave-dark-5120x2880.png";
      sha256 = "sha256-Q5ZtrIDtPZKOYohNt9NjPF6suV3rcw1HK8mx7+Ll4Ts=";
    };
    # https://github.com/lunik1/nix-wallpaper
    snowflake = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {};
  };
in {
  stylix = {
    enable = true;
    image = lib.mkDefault wallpapers.rose-pine;
    polarity = lib.mkDefault "dark";
    # https://tinted-theming.github.io/tinted-gallery/
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
  };
}
