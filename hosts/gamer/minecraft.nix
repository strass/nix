{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  # launcher
  home-manager.users.strass.home.packages = with pkgs; [prismlauncher];

  services.minecraft-servers = {
    enable = false;
    eula = true;
    openFirewall = true;
    servers.vanilla = {
      enable = true;
      jvmOpts = "-Xmx4G -Xms2G";

      # Specify the custom minecraft server package
      # package = pkgs.minecraftServers.vanilla-server;
    };
  };

  # TODO: server backups
}
