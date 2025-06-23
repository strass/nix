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
    impermanence.url = "github:nix-community/impermanence";
    lutgen-rs.url = "github:ozwaldorf/lutgen-rs";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    niri-flake.url = "github:sodiboo/niri-flake";

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
    impermanence,
    ...
  }: let
    # dnsConfig = {
    #   inherit (self) nixosConfigurations;
    #   extraConfig = import ./config/dns.nix;
    # };
  in {
    nix.settings = {
      trusted-users = ["root" "strass" "builder"];
      experimental-features = ["nix-command" "flakes"];
      # auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      # override the default substituters
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "http://nix-cache.router.local"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"

        "http://nix-cache.router.local"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-cache.router.local-001:JfeHCg9FX32dAjQXe2Mt2NkgiSLWMhIErOkXFZKwIwI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="

        "nix-cache.router.local:FdMJI11DQtnf3jk18u/jDj0kOySK1CbjKACQlt3gtZk="
      ];
    };

    nixosConfigurations = {
      live = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          fqdn = "live.local";
        };
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          home-manager.nixosModules.home-manager
          ./modules/user.strass.nix
          ./modules/defaults.nix
          {
            isoImage.makeEfiBootable = true;
            isoImage.makeUsbBootable = true;
          }
        ];
      };
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
          ./modules/user.builder.nix
          ./modules/defaults.nix
          ./hosts/framework/default.nix

          # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          quadlet-nix.nixosModules.quadlet
          vscode-server.nixosModules.default
          agenix.nixosModules.default

          niri.nixosModules.niri # It would be nice to move this to the niri config file
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

          # chaotic.nixosModules.nyx-cache
          # chaotic.nixosModules.nyx-overlay
          # chaotic.nixosModules.nyx-registry
          stylix.nixosModules.stylix

          ./modules/user.strass.nix
          ./modules/user.builder.nix
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
          impermanence.nixosModules.impermanence
          agenix.nixosModules.default

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
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          # fqdn = "mac-mini.local";
        };
        modules = [
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix

          ./hosts/mac-mini/default.nix
        ];
      };
    };
  };
}
