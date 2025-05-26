{
  hosts = {
    hive = {
      hostName = "hive";
      userName = "strass";
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIb/i6EN/iC/eEWBnwaEQG6/rK5UyR2Mj0gE+cpRijVB zakstrassberg@gmail.com";
      domainName = "zaks.pw";
      ip = "192.168.1.10";
    };
  };

  knownHosts = [
    {
      hostNames = [hosts.hive.domainName hosts.hive.ip];
      publicKeys = [hosts.hive.publicKey];
    }
  ];
}
