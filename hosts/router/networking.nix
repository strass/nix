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
