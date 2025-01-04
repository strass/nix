{lib, config, options, pkgs, ...}:
{
  imports = [
    ./hardware.nix
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "fridge"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable automatic login for the user.
  services.getty.autologinUser = "strass";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  modules = {
    ssh.enable = true;

    desktop = {
      niri.enable = true;
      waybar.enable = true;
      execOnStart = ["cog http://zaks.pw:2021/activities"];
    };

    # software = {

    # };
  };
 
}
