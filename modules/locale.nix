{lib, ...}: let
  inherit (lib.modules) mkDefault;
  # inherit (lib.my) mapModulesRec';
in {
  # Set your time zone.
  time.timeZone = mkDefault "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  i18n.extraLocaleSettings = mkDefault {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = mkDefault {
    layout = "us";
    variant = "";
  };
}
