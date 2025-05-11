{
  # File sharing
  services.netatalk = {
    enable = true;

    settings = {
      Global = {
        # "uam list" = "uams_guest.so, uams_clrtxt.so"; # needed for uploads from scanner
      };
      Homes = {
        "basedir regex" = "/home";
      };
      # public = {
      #   path = "/home/strass/public";
      #   "read only" = false;
      # };
    };
  };

  networking.firewall.allowedTCPPorts = [
    548
  ];
}
