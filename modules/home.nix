{ config, pkgs, ... }:

{
  home.username = "strass";
  home.homeDirectory = "/home/strass";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    git
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Zak Strassberg";
    userEmail = "zakstrassberg@gmail.com";
  };
}