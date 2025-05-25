# Install Flake
`sudo nixos-rebuild switch --flake github:strass/nix#fridge --impure --no-write-lock-file  --refresh`

# Restic
To start a backup: `systemctl start restic-backups-<NAME>.service`

To restore a backup: `sudo restic-<NAME> snapshots`

# TODO:
- [x] mac config
  - [ ] garbage collection
  - [x] linux-builder
- [ ] impermanence & btrfs
  - https://github.com/nix-community/impermanence
  - https://www.foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
  - https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
- [ ] dns/dhcp
  - both but not declarative? gravity or technitium
  - declarative combo unbound+kea
- backups
  - [x] restic backups
  - [ ] offsite backups
  - [ ] database backups
  - [ ] research restic providers
- [ ] vpn & tunnel
- [ ] distributed builds
- security
  - [ ] security.pki.certificateFiles

# Prior Art
- https://git.oat.zone/oat/nix-config
- https://codeberg.org/kiara/cfg
- https://github.com/Icy-Thought/snowflake
- https://github.com/georgewhewell/nixos-host/
- https://github.com/hlissner/dotfiles/
- https://nixos-and-flakes.thiscute.world/