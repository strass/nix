# Podman & Quadlet
# https://github.com/SEIAROTg/quadlet-nix
{
  pkgs,
  inputs,
  ...
}: {
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    # containers.storage.settings = {
    #   storage = {
    #     driver = "btrfs";
    #     runroot = "/run/containers/storage";
    #     graphroot = "/var/lib/containers/storage";
    #     options.overlay.mountopt = "nodev,metacopy=on";
    #   }; # storage
    # };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];
}
