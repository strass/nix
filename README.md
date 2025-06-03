# Install Flake
`sudo nixos-rebuild switch --flake github:strass/nix#framework`

# Restic
To start a backup: `systemctl start restic-backups-<NAME>.service`

To restore a backup: `sudo restic-<NAME> snapshots`

# TODO:
- [x] mac config
  - [ ] garbage collection
  - [x] linux-builder
- [x] impermanence & btrfs
  - https://github.com/nix-community/impermanence
  - https://www.foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
  - https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  - [x] btrfs via disko
  - [x] impermanence setup
  - [x] find modified files `cruft.sh`
    - [x] how to implement script?
  - [ ] revert subvolume on boot
  - [ ] tmpfiles.d https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
- [ ] dns/dhcp
  - both but not declarative? gravity or technitium
  - declarative combo unbound+kea
- backups
  - [x] restic backups
  - [ ] local backup replication
  - [ ] offsite backups
  - [ ] database backups
  - [x] research restic providers
- [ ] vpn & tunnel
- [x] distributed builds
- security
  - [ ] security.pki.certificateFiles
  - [ ] https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/
  - https://jamielinux.com/docs/openssl-certificate-authority/
  - https://easy-rsa.readthedocs.io/en/latest/advanced/
- nixos on kindle
  - https://github.com/schuhumi/alpine_kindle/

# Prior Art
- https://git.oat.zone/oat/nix-config
- https://codeberg.org/kiara/cfg
- https://github.com/Icy-Thought/snowflake
- https://github.com/georgewhewell/nixos-host/
- https://github.com/hlissner/dotfiles/
- https://nixos-and-flakes.thiscute.world/
- https://github.com/Atemu/nixos-config/
- https://github.com/chewblacka/nixos
- https://gitlab.com/Zaney/zaneyos/