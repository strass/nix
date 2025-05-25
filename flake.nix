{
  description = "strass' NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    stylix.url = "github:danth/stylix/release-25.05";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    agenix.url = "github:ryantm/agenix";

    # mac
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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
    agenix,
    nix-darwin,
    ...
  }: let
    # dnsConfig = {
    #   inherit (self) nixosConfigurations;
    #   extraConfig = import ./config/dns.nix;
    # };
  in {
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
      hive = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          fqdn = "zaks.pw";
          # pathConfig = import ./hosts/framework/config.nix; # better way to do this?
        };
        modules = [
          ./modules/user.strass.nix
          ./modules/defaults.nix
          ./hosts/hive/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          quadlet-nix.nixosModules.quadlet
          agenix.nixosModules.default
        ];
      };
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          fqdn = "framework.local";
          pathConfig = import ./hosts/framework/config.nix; # better way to do this?
        };
        modules = [
          hardware.nixosModules.framework-11th-gen-intel

          ./modules/user.strass.nix
          ./modules/defaults.nix
          ./hosts/framework/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          quadlet-nix.nixosModules.quadlet
          vscode-server.nixosModules.default
          agenix.nixosModules.default
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
          fqdn = "gamer.local";
        };
        modules = [
          hardware.nixosModules.asus-rog-strix-x570e # not quite what I have in there but I think it's close enough

          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
          stylix.nixosModules.stylix

          ./modules/user.strass.nix
          ./modules/defaults.nix
          ./hosts/gamer/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
        ];
      };
      router = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          fqdn = "router.local";
        };
        modules = [
          stylix.nixosModules.stylix

          ./modules/user.strass.nix
          ./modules/defaults.nix
          ./hosts/router/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
        ];
      };
    };

    darwinConfigurations = {
      "mac-mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix

          ./hosts/mac-mini/default.nix
        ];
      };
    };
  };
}
