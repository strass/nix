{}: {
  boot.kernel.sysctl = {
    # if you use ipv4, this is all you need
    "net.ipv4.conf.all.forwarding" = true;

    # If you want to use it for ipv6
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.${name}.accept_ra" = 2;
    "net.ipv6.conf.${name}.autoconf" = 1;
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    hostName = "router";
    nameserver = ["<DNS IP>"];
    # Define VLANS
    vlans = {
      wan = {
        id = 10;
        interface = "enp2s0";
      };
      lan = {
        id = 20;
        interface = "enp3s0";
      };
      iot = {
        id = 90;
        interface = "enp3s0";
      };
    };

    interfaces = {
      # Don't request DHCP on the physical interfaces
      enp2s0.useDHCP = false;
      enp3s0.useDHCP = false;

      # Handle the VLANs
      wan.useDHCP = false;
      lan = {
        ipv4.addresses = [
          {
            address = "10.1.1.1";
            prefixLength = 24;
          }
        ];
      };
      iot = {
        ipv4.addresses = [
          {
            address = "10.1.90.1";
            prefixLength = 24;
          }
        ];
      };
    };

    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          # enable flow offloading for better throughput
          flowtable f {
            hook ingress priority 0;
            devices = { ppp0, lan };
          }

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority filter; policy drop;

            # Allow trusted networks to access the router
            iifname {
              "lan",
            } counter accept

            # Allow returning traffic from ppp0 and drop everthing else
            iifname "ppp0" ct state { established, related } counter accept
            iifname "ppp0" drop
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            # enable flow offloading for better throughput
            ip protocol { tcp, udp } flow offload @f

            # Allow trusted network WAN access
            iifname {
                    "lan",
            } oifname {
                    "ppp0",
            } counter accept comment "Allow trusted LAN to WAN"

            # Allow established WAN to return
            iifname {
                    "ppp0",
            } oifname {
                    "lan",
            } ct state established,related counter accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority filter; policy accept;
          }

          # Setup NAT masquerading on the ppp0 interface
          chain postrouting {
            type nat hook postrouting priority filter; policy accept;
            oifname "ppp0" masquerade
          }
        }
      '';
    };
  };

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enp3s0";

    networkConfig = {
      Address = "192.168.238.1/24";
      Domains = ["~infra.largeandhighquality.com"];
      DNS = "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3#zhloe.infra.largeandhighquality.com";
      DNSOverTLS = true;
      DNSSEC = true;
      DHCPPrefixDelegation = true;
      IPv6SendRA = true;
    };

    ipv6SendRAConfig = {
      OtherInformation = true;
      RouterLifetimeSec = 5400;
      DNS = "_link_local";
      Domains = "infra.largeandhighquality.com";
      DNSLifetimeSec = 16200;
    };

    extraConfig = ''
      [IPv6Prefix]
      Prefix=fda9:51fe:3bbf:c9f::/64
      Assign=true
    '';
  };

  systemd.network.networks.wan = {
    enable = true;
    matchConfig.Name = "enp2s0";

    networkConfig = {
      DHCP = "ipv4";
      DNS = ["fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3#zhloe.infra.largeandhighquality.com"];
      DNSOverTLS = true;
      DNSSEC = true;
      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      ClientIdentifier = "mac";
      UseDNS = false;
    };

    dhcpV6Config = {
      UseDNS = false;
    };

    routes = [
      {
        Type = "blackhole";
        Destination = "192.168.100.1/32";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    ethtool # manage NIC settings (offload, NIC feeatures, ...)
    tcpdump # view network traffic
    conntrack-tools # view network connection states
  ];

  services.dhcpd4 = {
    enable = true;
    interfaces = ["lan" "iot"];
    extraConfig = ''
      option domain-name-servers 10.5.1.10, 1.1.1.1;
      option subnet-mask 255.255.255.0;

      subnet 10.1.1.0 netmask 255.255.255.0 {
        option broadcast-address 10.1.1.255;
        option routers 10.1.1.1;
        interface lan;
        range 10.1.1.128 10.1.1.254;
      }

      subnet 10.1.90.0 netmask 255.255.255.0 {
        option broadcast-address 10.1.90.255;
        option routers 10.1.90.1;
        option domain-name-servers 10.1.1.10;
        interface iot;
        range 10.1.90.128 10.1.90.254;
      }
    '';
  };

  services.avahi = {
    enable = true;
    reflector = true;
    interfaces = [
      "lan"
      "iot"
    ];
  };

  services.openssh = {
    enable = true;
    hardening = true;
  };
}
# https://github.com/philipwilk/nixos/blob/4fec9d73bfa7b1ecb490186522de38d25ee81e69/homelab/router/systemd.nix
# { config, lib, ... }:
# let
#   routerIp = "192.168.1.1";
#   cfg = config.homelab.router.systemd;
#   lan = config.homelab.router.devices.lan;
#   wan = config.homelab.router.devices.wan;
#   dns4 = "1.1.1.1 9.9.9.9";
#   dns6 = "2606:4700:4700::1111 2620:fe::fe";
#   dnsCfg = {
#     DNS = "${dns6} ${dns4}";
#     DNSSEC = "yes";
#     DNSOverTLS = "yes";
#   };
# in
# {
#   options.homelab.router.systemd = {
#     enable = lib.mkOption {
#       type = lib.types.bool;
#       default = config.homelab.router.enable;
#       example = true;
#       description = ''
#         Whether to enable systemd network configuration.
#       '';
#     };
#     ipRange = lib.mkOption {
#       type = lib.types.str;
#       default = "192.168.1.0/16";
#       example = "192.168.1.0/24";
#       description = ''
#         IP4 address range to use for the lan
#       '';
#     };
#   };
#   config = lib.mkIf cfg.enable {
#     networking.useDHCP = false;
#     systemd.network = {
#       enable = true;
#       links = {
#         "link-${wan}" = {
#           matchConfig.Name = wan;
#           linkConfig = {
#             # WAN link is defaulting to 100mbps
#             # Think it is due to spurious rx errors
#             # Need to replace the link cable so it doesn't happen in the first place
#             # but i cba atm
#             BitsPerSecond = "1G";
#             Duplex = "full";
#           };
#         };
#         "link-${lan}" = {
#           matchConfig.Name = lan;
#           linkConfig = {
#             # WAN link is defaulting to 100mbps
#             # Think it is due to spurious rx errors
#             # Need to replace the link cable so it doesn't happen in the first place
#             # but i cba atm
#             BitsPerSecond = "1G";
#             Duplex = "full";
#           };
#         };
#       };
#       config.networkConfig.IPv6Forwarding = "yes";
#       networks = {
#         "10-${wan}" = {
#           matchConfig.Name = wan;
#           networkConfig = lib.mkMerge [
#             {
#               DHCP = "yes";
#               IPv6AcceptRA = "yes";
#               LinkLocalAddressing = "ipv6";
#               IPv4Forwarding = "yes";
#             }
#             dnsCfg
#           ];
#           dhcpV4Config = {
#             UseHostname = "no";
#             UseDNS = "no";
#             UseNTP = "no";
#             UseSIP = "no";
#             UseRoutes = "no";
#             UseGateway = "yes";
#           };
#           ipv6AcceptRAConfig = {
#             UseDNS = "no";
#             DHCPv6Client = "yes";
#           };
#           dhcpV6Config = {
#             WithoutRA = "solicit";
#             UseDelegatedPrefix = true;
#             UseHostname = "no";
#             UseDNS = "no";
#             UseNTP = "no";
#           };
#           linkConfig.RequiredForOnline = "routable";
#         };
#         "15-${lan}" = {
#           matchConfig.Name = lan;
#           networkConfig = lib.mkMerge [
#             {
#               IPv6AcceptRA = "no";
#               IPv6SendRA = "yes";
#               LinkLocalAddressing = "ipv6";
#               DHCPPrefixDelegation = "yes";
#               DHCPServer = "yes";
#               Address = "${routerIp}/16";
#               IPv4Forwarding = "yes";
#               IPMasquerade = "ipv4";
#             }
#             dnsCfg
#           ];
#           dhcpServerConfig = {
#             EmitRouter = "yes";
#             EmitDNS = "yes";
#             DNS = dns4;
#             EmitNTP = "yes";
#             NTP = routerIp;
#             PoolOffset = 100;
#             ServerAddress = "${routerIp}/16";
#             UplinkInterface = wan;
#             DefaultLeaseTimeSec = 1800;
#           };
#           dhcpServerStaticLeases = [
#             # {
#             #   # Idac for example
#             #   Address = "192.168.1.50";
#             #   MACAddress = "54:9f:35:14:57:3e";
#             # }
#           ];
#           linkConfig.RequiredForOnline = "no";
#           ipv6SendRAConfig = {
#             EmitDNS = "yes";
#             DNS = dns6;
#             EmitDomains = "no";
#           };
#           dhcpPrefixDelegationConfig.SubnetId = "0x1";
#         };
#       };
#     };
#     # Open ports for dhcp server on lan
#     networking.firewall.interfaces.${lan}.allowedUDPPorts = [
#       67
#       68
#     ];
#     networking.firewall.allowedTCPPorts = [
#       80
#       443
#       636
#       389
#       25
#       465
#       993
#       22420
#       22
#       34197
#     ];
#   };
# }

