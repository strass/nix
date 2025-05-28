{
  hosts = {
    router = {
      hostName = "router";
      userName = "strass";
      publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlrsIvuSBHfQakJTUELXUZbXasCpa8CS1KD9czSTKMW strass@nixos"];
      domainName = "router.local";
      ip = "192.168.1.92";
    };
    hive = {
      hostName = "hive";
      userName = "strass";
      publicKeys = [];
      domainName = "zaks.pw";
      ip = "192.168.1.10";
    };
    framework = {
      publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyrhHvlLOPJ1UF7r5QgytPa9GHwObXXkQdH/VAJXB4+ zakstrassberg@gmail.com"];
    };
    gamer = {
      hostName = "gamer";
      userName = "strass";
      publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG/pdJKfHUsHVD04Fx87BwCyHeBg5Z57AjLUxT4rTh2 strass@gamer"];
    };
  };

  knownHosts = [
    {
      hostNames = [hosts.hive.domainName hosts.hive.ip];
      publicKeys = [hosts.hive.publicKey];
    }
  ];
}
