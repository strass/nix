{
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    # Required for DE to launch.
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = lib.mkDefault true;
      };
    };
    # Enable Desktop Environment.
    desktopManager.gnome.enable = true;
  };
  # Ensure gnome-settings-daemon udev rules are enabled.
  services.udev.packages = with pkgs; [gnome-settings-daemon];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "strass";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Disable some GNOME applications that are not needed.
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ];
}
