{}: let
  # port = 9000;
  dataDir = "/var/lib/garage/data";
  configDir = "/var/lib/garage/config";
  # certificatesDir = "/var/lib/garage/certificates";
in {
  services.garage = {
    enable = true;
    environmentFile = "";
    extraEnvironment = {};
    logLevel = "info";
    settings = {
      metadata_dir = configDir; # fast disk if possible
      data_dir = dataDir; # can be on slower disk
    };
  };
}
