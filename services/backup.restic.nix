{pkgs, ...}: let
in {
  services.restic = {
    enable = true;

    server = {
      # enable = true;
      extraFlags = ["--no-auth"];
      privateRepos = true;
    };
  };
}
