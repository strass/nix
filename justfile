switch:
  nixos-rebuild switch --flake .#$(hostname) --use-remote-sudo

switch-mac:
  sudo darwin-rebuild switch --flake .#$(hostname)

update:
  nix flake update

clean:
  nix-store -gc

facter:
  sudo nix run \
  --option experimental-features "nix-command flakes" \
  --option extra-substituters https://numtide.cachix.org \
  --option extra-trusted-public-keys numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE= \
  github:numtide/nixos-facter -- -o facter.json

anywhere-facter:
  nix run github:nix-community/nixos-anywhere --option experimental-features "nix-command flakes" -- --generate-hardware-config nixos-facter ./hosts/gamer/facter.json --flake .#gamer --target-host strass@gamer.local

iso:
  nix build .#nixosConfigurations.live.config.system.build.isoImage \
  --option experimental-features "nix-command flakes" 