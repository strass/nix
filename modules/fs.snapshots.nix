{...}: {
  # A snapshot is not a backup: snapshots work by use of BTRFS’ copy-on-write behaviour.
  # A snapshot and the original it was taken from initially share all of the same data blocks.
  # If that data is damaged in some way (cosmic rays, bad disk sector, accident with dd to the disk),
  # then the snapshot and the original will both be damaged.
  #
  # Snapshots are useful to have local online “copies” of the filesystem that can be referred back to,
  # or to implement a form of deduplication, or to fix the state of a filesystem for making a full backup
  # without anything changing underneath it. They do not in themselves make your data any safer.
  services.snapper = {
    snapshotRootOnBoot = true;
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = ["strass"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
    };
  };
}
