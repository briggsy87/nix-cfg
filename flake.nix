{
  description = "Multi-platform Nix configuration: macOS (nix-darwin) + NixOS (ThinkPad)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # macOS support
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # User environment management
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # System-wide theming
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, stylix, ... }:
    let
      # Host configurations - add new hosts here
      hosts = {
        m4pro = {
          system = "aarch64-darwin";
          username = "kyle.briggs";
          platform = "darwin";
        };
        thinkpad = {
          system = "x86_64-linux";
          username = "briggsy";
          platform = "nixos";
        };
      };

      # Helper to create system configurations
      mkSystem = hostname: config:
        let
          inherit (config) system username platform;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          homeConfig = { ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              stylix.homeModules.stylix
            ];
            home-manager.users.${username} = import ./home {
              inherit platform username;
            };
          };
        in
          if platform == "darwin" then {
            name = hostname;
            value = darwin.lib.darwinSystem {
              inherit system;
              specialArgs = { inherit hostname username; };
              modules = [
                ./hosts/${hostname}.nix
                home-manager.darwinModules.home-manager
                stylix.darwinModules.stylix
                homeConfig
              ];
            };
          } else {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit hostname username; };
              modules = [
                ./hosts/${hostname}.nix
                home-manager.nixosModules.home-manager
                stylix.nixosModules.stylix
                homeConfig
              ];
            };
          };

    in {
      # Generate darwin configurations
      darwinConfigurations = builtins.listToAttrs (
        map (h: mkSystem h hosts.${h}) (builtins.filter (h: hosts.${h}.platform == "darwin") (builtins.attrNames hosts))
      );

      # Generate nixos configurations
      nixosConfigurations = builtins.listToAttrs (
        map (h: mkSystem h hosts.${h}) (builtins.filter (h: hosts.${h}.platform == "nixos") (builtins.attrNames hosts))
      );

      # Formatter for all systems
      formatter = {
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      };
    };
}
