{
  inputs,
  pkgs,
  fqdn,
  ...
}: {
  services.rtorrent = {
    enable = true;
    # package = pkgs.jesec-rtorrent;
    port = 50000;
    dataDir = "/var/lib/rtorrent";
    openFirewall = true;
    downloadDir = "/var/lib/rtorrent/download";
  };
}
