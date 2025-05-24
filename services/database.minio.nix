{}: let
  port = 9000;
  dataDir = "/var/lib/minio/data";
  configDir = "/var/lib/minio/config";
  certificatesDir = "/var/lib/minio/certificates";
in {
  services.minio = {
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
