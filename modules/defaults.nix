{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.modules) mkAliasOptionModule mkDefault mkIf;
  # inherit (lib.my) mapModulesRec';
in {
  imports = [
    # inputs.nix-colors.homeManagerModules.default
    #inputs.hyprland.nixosModules.default
    #inputs.lix-module.nixosModules.default

    # Load my modules
    ../services/avahi.nix
    ./ssh.nix
    ./home-manager.ni
    ./nix.nix
  ];

  # Linux only (so not in home-manager config)
  home-manager.users.strass = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
    # This is crucial to ensure the systemd services are (re)started on config change
    systemd.user.startServices = "sd-switch";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  system = {
    stateVersion = "25.05";
    configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  };

  # boot = {
  #   kernelPackages = mkDefault pkgs.unstable.linuxPackages_latest;
  #   kernelParams = ["pcie_aspm.policy=performance"];
  # };

  # Set your time zone.
  time.timeZone = mkDefault "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  i18n.extraLocaleSettings = mkDefault {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = mkDefault {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
    unrar
    unzip
    micro
    curl
    wget
    desktop-file-utils
    shared-mime-info
    xdg-user-dirs
    xdg-utils
    fish
    # fun fact! when using flakes not having
    # git available as a global package while operating
    # on a git repository makes nixos-rebuild break,
    # rendering your system unable to rebuild.
    # nix is really cool
    git
    fuzzel
    firefox
    cog
    zoxide
    eza
    glances
    bat
    xcp
    rm-improved
    dysk
    dust
    neovim
    direnv
    sqlite
    just
    alejandra
  ];

  # if I mkDefault this then it conflicts with the nano default from nixos
  environment.variables.EDITOR = "nvim";
}
