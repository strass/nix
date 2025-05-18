{
  description = "strass' NixOS configuration";

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
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    quadlet-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";
    niri.url = "github:sodiboo/niri-flake";
    waybar.url = "github:Alexays/Waybar";
    hyprlock.url = "github:hyprwm/hyprlock";
    stylix.url = "github:danth/stylix/release-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # grab ssh public keys from GitHub to be used with `openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];`
    ssh-keys = {
      url = "https://github.com/strass.keys"; # https://forgejo.zaks.pw/strass.keys
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    hardware,
    nixpkgs-unstable,
    stylix,
    quadlet-nix,
    vscode-server,
    chaotic,
    ...
  }: {
    nix.settings.trusted-users = ["strass"];
    nixConfig = {
      # override the default substituters
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./modules/user.nix
          ./modules/defaults.nix
          ./hosts/framework/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          hardware.nixosModules.framework-11th-gen-intel
          stylix.nixosModules.stylix
          quadlet-nix.nixosModules.quadlet
          vscode-server.nixosModules.default
          "${nixpkgs-unstable}/nixos/modules/services/web-apps/olivetin.nix"
        ];
      };
      gamer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry

          ./modules/user.nix
          ./modules/defaults.nix
          ./hosts/gamer/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
        ];
      };
      fridge = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./modules/user.nix
          ./modules/defaults.nix
          ./hosts/fridge/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
