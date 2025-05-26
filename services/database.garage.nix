{}: let
  port = 9000;
  dataDir = "/var/lib/garage/data";
  configDir = "/var/lib/garage/config";
  certificatesDir = "/var/lib/garage/certificates";
in {
  services.garage = {
    enable = true;
    listenAddress = ":9000";
    consoleAddress = ":${toString port}";
    dataDir = dataDir;
    configDir = configDir;
    certificatesDir = certificatesDir;

    # TODO: secretify these
    secretKey = "min";
    accessKey = "min";
  };
}
