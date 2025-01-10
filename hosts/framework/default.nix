{
imports = [
    ./hardware.nix
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework"; # Define your hostname.
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

   # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

    # Install firefox.
  programs.firefox.enable = true;




  modules = {
    ssh.enable = true;

    # desktop = {
    #   niri.enable = true;
    #   waybar.enable = true;
    #   execOnStart = ["cog http://zaks.pw:2021"];
    # };
  };

  #  fileSystems."/home/strass/downloads" = {
  #   device = "none";
  #   fsType = "tmpfs";
  #   options = [ "size=2G" "mode=777" ];
  # };

}
