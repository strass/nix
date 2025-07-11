{
  inputs,
  pkgs,
  fqdn,
  ...
}: {
  services.rtorrent = {
    enable = true;
    port = 25000;
    dataDir = "/var/lib/rtorrent";
    openFirewall = false;
    downloadDir = "/var/lib/rtorrent/download";
  };

  networking.firewall = {
    allowedTCPPorts = [
      25000
    ];
  };
}
