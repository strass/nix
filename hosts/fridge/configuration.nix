{
  config,
  pkgs,
  ...
}: {
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.strass = {
    isNormalUser = true;
    description = "Zak";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [ alacritty fuzzel firefox cog];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "strass";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];
  environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
