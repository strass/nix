let
  strasspub1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIb/i6EN/iC/eEWBnwaEQG6/rK5UyR2Mj0gE+cpRijVB";
  strasspub2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItSvybidJBVJwlSo1Q23NKoheDYsGJp7O/LxVwgJztP";
  strasspub3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfd5dsV0sp4zQzo8y1Kuylb5HMvSn+Gw35qUoHuvPWI";
  users = [strasspub1 strasspub2 strasspub3];

  macmini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIb/i6EN/iC/eEWBnwaEQG6/rK5UyR2Mj0gE+cpRijVB";
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqPePuKDHPqpUHri+4u3E6UhYJvGsWzCWO88yJVKvss";
  systems = [macmini framework];
in {
  "github-auth.age".publicKeys = users ++ systems;
}
