{
  inputs,
  pkgs,
  fqdn,
  ...
}: {
  services.rtorrent = {
    enable = true;
    port = 50000;
    dataDir = "/var/lib/rtorrent";
    openFirewall = true;
    downloadDir = "${services.rtorrent.dataDir}/download";
  };
}
