{
  lib,
  pkgs,
  ...
}: {
  users.users.restic = {
    isSystemUser = true;
  };

  # # security wrapper to give restic the capability to read anything on the filesystem as if it were running as root.
  # security.wrappers.restic = {
  #   source = "${pkgs.restic.out}/bin/restic";
  #   owner = "restic";
  #   group = "users";
  #   permissions = "u=rwx,g=,o=";
  #   capabilities = "cap_dac_read_search=+ep";
  # };

  services.restic = {
    backups = {
      home = {
        # user = "restic";
        initialize = true;
        repository = "rest:http://localhost:8000/framework/home";
        paths = [
          "/home/strass/"
        ];
        timerConfig = {
          onCalendar = "daily";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
        extraBackupArgs = let
          ignorePatterns = [
            "/home/*/.local/share/Trash"
            "/home/*/.cache"
            "/home/*/Downloads"
            "/home/*/.npm"
            "/home/*/Games"
            "/home/*/.local/share/containers"
            ".cache"
            ".tmp"
            ".log"
            ".Trash"
          ];
          ignoreFile =
            builtins.toFile "ignore"
            (lib.foldl (a: b: a + "\n" + b) "" ignorePatterns);
        in ["--exclude-file=${ignoreFile}"];
        passwordFile = "/home/strass/.cache/restic-pw";
      };
    };
  };
}
