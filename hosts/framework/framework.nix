{
hardware, ...
  
}: {
  services.fwupd.enable = true;
  services.fwupd.extraRemotes = [ "lvfs-testing" ];
  # Might be necessary once to make the update succeed
  services.fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;

  imports = [
    hardware.framework-11-gen-intel
  ];
}
