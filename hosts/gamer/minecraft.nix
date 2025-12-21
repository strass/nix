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
    enable = true;
    eula = true;
    openFirewall = true;

    servers.vanilla = {
      enable = true;
      jvmOpts = "-Xmx4G -Xms2G";
      # managed imperatively via /whitelist command
      # whitelist = {
      #   overshee = "";
      #   malaug = "";
      #   ibsailn = "";
      # };
      # Specify the custom minecraft server package
        package = pkgs.vanillaServers.vanilla-1_21
      };
  };

  # TODO: server backups
}
