# nix eval --expr 'import ./config/known-hosts.nix' --json --impure | jq .knownHosts
rec {
  hosts = {
    router = {
      hostName = "router";
      publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlrsIvuSBHfQakJTUELXUZbXasCpa8CS1KD9czSTKMW strass@nixos"];
      domainName = "router.local";
      ip = "192.168.1.92";
    };
    hive = {
      hostName = "hive";
      publicKeys = [];
      domainName = "zaks.pw";
      ip = "192.168.1.10";
    };
    framework = {
      hostName = "framework";
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWPWB0xjBd2vyDAT+kHcQJ/aiuPm5qjOEmGPTcjQdVe root@framework"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyrhHvlLOPJ1UF7r5QgytPa9GHwObXXkQdH/VAJXB4+ zakstrassberg@gmail.com"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjzA46DOhnvOtdOK/KdVPeQvbD7UyLyzMNAktGjDE3deX3thO/Q/9tgT89mK4SH52lHm/bcS6fg/RzvC0d7kbuqjw/l/LYCV/ZK0uEhXqk1vrZzCTEhL5o7kv7ZQAkoCdwVdZdTgAffdvhMDXKBtUNtLp/GnTCrF7ck0T/wn7kYJLoOn1pGQJ7Y2acwOGJAv60aI8b14LRO3nvrzrVFqPoZcosDT9rknBnxlLIIGLz/UmhzOQeSi7Bp2RhLzoXPiLcMS3oNxLeGvks+1KuAXmsMlLLLXCGu0Pkf5uaEWwIyk9B9fv19YEEsV5h3LcdM3j7P9VJ0SlxX5odOBZrREydyR8/I6oKauYs8E/Qc7IWqRXGb5xQAZkseZOl5z1JgzATuwgFqDIfBxg13gPpMry8r6N/U+zIhK1O7OA4iCmpgaqmkRtmgQmRU0NZ2/Ad3KFKTSHHpxgNRy8q7d9bL3EJUBsF6PbPvr50dfdH7go6xur2DwVzQFa3osOEeAC29ucEfpsYQ2Bf5Recvo5pj9pPST3nfH/gYYwlgBDfva+acTioee8dyAMo8ptoTyxAN2Xf6zgVY9GNF/E7c6QfzkuW5/32amWCjlsmjZuDvT47NEa20m1qk5+QTSfYrQNGQ1UDpwF+vBOlATRBFt+WgGZynNZsVW8Z9RfeNfsRNOdudw== root@nixos"
      ];
      domainName = "framework.local";
      ip = "192.168.1.71";
    };
    gamer = {
      hostName = "gamer";
      domainName = "gamer.local";
      ip = "192.168.1.123";
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOkjcaN4GHRS55JTVDQjKa4cKSdn2pAOEMvttLiTSEx strass@gamer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnJRJdsV4r7reD9860HXZibvJ6RKoCO4N5NFOXDiQtZ root@gamer"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM5BreWIM2ffeI9+evDQECrEOPPwZ5qKwTq+WwGb2mJ"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8OyPDvEgUYHbouf1pxiz1T5U9y/AE/G5pJQKz9RAcagjLa7zrHFTGHbm6B2LEmCIoS4PWUdhO03q8boTGqqQp4DGA/3Da8hKQJmkZf0tGYmte+8E3gphwHGYOm8kSI201jfX8M7fy+XXpc+Ib3OTfsFx37iwLaZ0pn83MAnBr3MpuIWnHZ6FYJzIUsbE8a8+dZtTFfk6EaebVbnoP9lwKgyRWOz3s323A6239WZ6GO85meDLkJqD/CZMFPgbQhgmL3FoyNy2sOJL7305dqWRGlvPd+ojea5cirJgQ/Yu8Qz39bj+fnnpLjES5+0kTJl5quModPHVa/nafi2yHmH60urpbVwCX4RRBphGXrASAMfNirZlCdMCjfl/H+Dh83PEXl6SZg95fsF2P4po1Fkr9Gd4r6UVXtRqK0QZdymcjDI84AdGnb/PYZP8HW1JACXnhPREOOW2W/t41GAytH6qDR/yKMMaqUGx1lEZ62aSAMhEsoQUoJfx4gri1TNwuAfugLkkp9m/l+j7YIBaBNtl3SnvpbbWbToXzAfTRErRMTwgegk4fjpOQ2xeBUR3/i5AjolxzsoSihYIC3RuTgRrD20DpMlWJknQI+FTSBQatC/vMHj6mQEY1/0VfD7iDVcRaWV8wSVJcFVvC+hOXUBli1edaPr0M5htuBMpuFPuYvQ=="
      ];
    };
  };

  knownHosts = builtins.listToAttrs (
    builtins.concatMap
    (hostId: let
      host = hosts.${hostId};
    in
      builtins.map
      (key: let
        host = hosts.${hostId};

        parts = builtins.filter (x: x != []) (builtins.split " " key);
        keyType = builtins.elemAt (builtins.split "-" (builtins.elemAt parts 0)) 2;
        comment =
          if builtins.length parts >= 3
          then builtins.elemAt parts 2
          else "TODO"; # I'd like to get the index here
        sanitized = builtins.replaceStrings ["@" "." " "] ["_" "_" "_"] comment;
      in {
        name = "${hostId}-${keyType}-${sanitized}";
        value = {
          publicKey = key;
          hostNames = builtins.filter (x: x != null) [hostId host.domainName or null host.ip or null];
        };
      })
      host.publicKeys)
    (builtins.attrNames hosts)
  );

  authorizedKeys = builtins.concatLists (builtins.attrValues (builtins.mapAttrs (_: host: host.publicKeys) hosts));
}
