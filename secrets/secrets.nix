let
  strasspub1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIb/i6EN/iC/eEWBnwaEQG6/rK5UyR2Mj0gE+cpRijVB";
  strasspub2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItSvybidJBVJwlSo1Q23NKoheDYsGJp7O/LxVwgJztP";
  strasspub3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfd5dsV0sp4zQzo8y1Kuylb5HMvSn+Gw35qUoHuvPWI";
  users = [strasspub1 strasspub2 strasspub3];

  macmini = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIb/i6EN/iC/eEWBnwaEQG6/rK5UyR2Mj0gE+cpRijVB";
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyrhHvlLOPJ1UF7r5QgytPa9GHwObXXkQdH/VAJXB4+ zakstrassberg@gmail.com";
      router-ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0Z4CCxWItAGBy00QzkmaYQtBdHdmyEVlVNLhzw7WMn" ;
      router-rsa = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbwb7ZWPN7qLvJ04mkWuPy/v3ggdWGa5XWUOBIRoBaDcGSTisvE+5Y3XDxrq7iWBWc4swhdBjv5FTo2qYGurDEqE56Wa6UKTwQ7i4paITTZzwoDjRtMlsDaMgKNNDkHRrmjKFdOt4fdqQikyUeZB+7j/kEqyDmPDy8K3/SLQSFyjbhBJ+d8qG87s7lfmWqQJF0qzQst2jdh9Es3L+q8G/RnCPuGfYLSVkhhQJpphtZEKT9+taesUdrppUzuEssWwcFoMOW3GMx3jocd2u5/wDTtWc152j9nOdVJQ3k+jzpq+i0vxxprGLj5r5H4nues7vgBVpb7biAjvquxZszAUZe+jBnwhzqFYY1ffIRFtN2ApqxUSOA4lUVX3zRslkT+DuCwujAoouRHUYtM1Ua5w7VX6mFtkseyJQPmLEF/3rvmmPaAUzpSQJ0VImwanA4V7eh/V83kmAWEM3QwyYRIuUCvZN6r9e3qM3vVpLA1g1uK9dizjPT8SQKVB3em1VqgMnFbzSGHdfCtBXHz9Bhl6GrswOjq/1rz1xWJE+TY/dZuUjoV0QvCklgFwIW6SRSzsP87b5rR6w3FslW0aK4exqWUrbh9MRELpFKdrkdcBC8cwdDUNEH2NGibWc/5x+z2jLsDEQAy5DAr+suPt610q26VyGg/O6ZfCvoSuhS+2V74Q==";

  systems = [macmini framework router-ed25519 router-rsa];
in {
  "github-auth.age".publicKeys = users ++ systems;
  "attic-token.age".publicKeys = users ++ systems;
}
