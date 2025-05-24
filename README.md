# Install Flake
`sudo nixos-rebuild switch --flake github:strass/nix#fridge --impure --no-write-lock-file  --refresh`

# Restic
To start a backup: `systemctl start restic-backups-<NAME>.service`

To restore a backup: `sudo restic-<NAME> snapshots`

# Prior Art
- https://git.oat.zone/oat/nix-config
- https://codeberg.org/kiara/cfg
- https://github.com/Icy-Thought/snowflake
- https://github.com/georgewhewell/nixos-host/
- https://github.com/hlissner/dotfiles/
- https://nixos-and-flakes.thiscute.world/