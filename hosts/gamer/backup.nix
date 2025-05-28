{pkgs, ...}: {
  users.users.restic = {
    isNormalUser = true;
  };

  # security wrapper to give restic the capability to read anything on the filesystem as if it were running as root.
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic = {
    backups = {
      saves = {
        user = "restic";
        initialize = true;
        repository = "rest:http://framework.local:8000/gamer/backup";
        paths = [
          "/home/strass/.local/share/godot/app_userdata/SpaceIdle"
        ];
        timerConfig = {
          onCalendar = "hourly";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
      };
    };
  };
}
