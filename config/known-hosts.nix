{
  hosts = {
    router = {
      hostName = "router";
      userName = "strass";
      publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0Z4CCxWItAGBy00QzkmaYQtBdHdmyEVlVNLhzw7WMn" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbwb7ZWPN7qLvJ04mkWuPy/v3ggdWGa5XWUOBIRoBaDcGSTisvE+5Y3XDxrq7iWBWc4swhdBjv5FTo2qYGurDEqE56Wa6UKTwQ7i4paITTZzwoDjRtMlsDaMgKNNDkHRrmjKFdOt4fdqQikyUeZB+7j/kEqyDmPDy8K3/SLQSFyjbhBJ+d8qG87s7lfmWqQJF0qzQst2jdh9Es3L+q8G/RnCPuGfYLSVkhhQJpphtZEKT9+taesUdrppUzuEssWwcFoMOW3GMx3jocd2u5/wDTtWc152j9nOdVJQ3k+jzpq+i0vxxprGLj5r5H4nues7vgBVpb7biAjvquxZszAUZe+jBnwhzqFYY1ffIRFtN2ApqxUSOA4lUVX3zRslkT+DuCwujAoouRHUYtM1Ua5w7VX6mFtkseyJQPmLEF/3rvmmPaAUzpSQJ0VImwanA4V7eh/V83kmAWEM3QwyYRIuUCvZN6r9e3qM3vVpLA1g1uK9dizjPT8SQKVB3em1VqgMnFbzSGHdfCtBXHz9Bhl6GrswOjq/1rz1xWJE+TY/dZuUjoV0QvCklgFwIW6SRSzsP87b5rR6w3FslW0aK4exqWUrbh9MRELpFKdrkdcBC8cwdDUNEH2NGibWc/5x+z2jLsDEQAy5DAr+suPt610q26VyGg/O6ZfCvoSuhS+2V74Q=="];
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
  };

  knownHosts = [
    {
      hostNames = [hosts.hive.domainName hosts.hive.ip];
      publicKeys = [hosts.hive.publicKey];
    }
  ];
}
