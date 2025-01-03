{
  description = "NixOS Config";

  inputs = {
    # NixOS official package source, here using the nixos-24.11 branch
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        # home-manager, used for managing user configuration
      home-manager = {
        url = "github:nix-community/home-manager/release-24.11";
        # The `follows` keyword in inputs is used for inheritance.
        # Here, `inputs.nixpkgs` of home-manager is kept consistent with
        # the `inputs.nixpkgs` of the current flake,
        # to avoid problems caused by different versions of nixpkgs.
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

    nixosConfigurations = {
      fridge = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/fridge/default.nix
          ./modules/ssh.nix
          # ./modules/user.nix # has some libraries I dont have implemented

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.strass = import ./modules/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
    
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  };
}