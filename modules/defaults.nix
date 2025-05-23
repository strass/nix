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
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule ["hm"] ["home-manager" "users" "strass"]) # used to be ["home-manager" "users" config.user.name]
    # inputs.nix-colors.homeManagerModules.default
    #inputs.hyprland.nixosModules.default
    #inputs.lix-module.nixosModules.default

    # Load my modules
    ../services/avahi.nix
    ./ssh.nix
  ];

  hm.imports = [
    #inputs.hyprland.homeManagerModules.default
  ];
  home-manager.backupFileExtension = "hm-backup";

  # Common config for all nixos machines;
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  nixpkgs.config.allowUnfree = lib.mkDefault true;

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

  nix = {
    package = pkgs.nixVersions.stable;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  system = {
    stateVersion = "25.05";
    configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  };
  hm.home.stateVersion = config.system.stateVersion;
  # Mods, release the spores into his body. thank you
  hm.home.enableNixpkgsReleaseCheck = false;

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
  ];

  # if I mkDefault this then it conflicts with the nano default from nixos
  environment.variables.EDITOR = "nvim";

  documentation.nixos.enable = mkDefault false;

  nix.optimise.automatic = true;
  nix.optimise.dates = ["03:45"]; # Optional; allows customizing optimisation schedule
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
