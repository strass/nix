{
  networking.firewall = {
    allowedTCPPorts = [20 21];
    #                        connectionTrackingModules = [ "ftp" ];
  };

  users.users.scanner = {
    isNormalUser = true;
    password = "password";
    extraGroups = ["vsftpd"];
  };
  systemd.tmpfiles.rules = ["d /var/ftp 2770 vsftpd vsftpd - -"];
  services.vsftpd = {
    enable = true;
    #   cannot chroot && write
    #    chrootlocalUser = true;
    writeEnable = true;
    localUsers = true;
    userlist = ["scanner"];
    userlistEnable = true;

    localRoot = "/var/ftp";
    extraConfig = ''
      local_umask=007
    '';
  };
}
