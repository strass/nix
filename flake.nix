{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
    niri.url = "github:sodiboo/niri-flake";
    waybar.url = "github:Alexays/Waybar";
    hyprlock.url = "github:hyprwm/hyprlock";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
  

    nixosConfigurations = {
      fridge = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/defaults.nix
          ./hosts/fridge/default.nix
          ./modules/ssh.nix
          ./modules/niri.nix
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
  };
}