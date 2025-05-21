switch:
  nixos-rebuild switch --flake .#$(hostname)

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