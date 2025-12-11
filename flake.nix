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

    # macOS app integration for Spotlight/Launchpad
    mac-app-util.url = "github:hraban/mac-app-util";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # System-wide theming
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, mac-app-util, nix-homebrew, stylix, ... }@inputs:
    let
      # Host configurations - add new hosts here
      hosts = {
        m4pro = {
          system = "aarch64-darwin";
          username = "kyle.briggs";
          platform = "darwin";
          profile = "work";  # work or personal (defaults to personal if not set)
        };
        thinkpad = {
          system = "x86_64-linux";
          username = "briggsy";
          platform = "nixos";
          profile = "personal";
        };
      };

      # Helper to create system configurations
      mkSystem = hostname: config:
        let
          inherit (config) system username platform;
          profile = config.profile or "personal";  # Default to personal if not specified
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          lib = nixpkgs.lib;

          homeConfig = { ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              stylix.homeModules.stylix
            ] ++ lib.optionals (platform == "darwin") [
              # TODO: Uncomment when mac-app-util is enabled
              #inputs.mac-app-util.homeManagerModules.default
            ];
            home-manager.users.${username} = import ./home {
              inherit platform username profile;
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
                nix-homebrew.darwinModules.nix-homebrew
                # TODO: Uncomment when mac-app-util is enabled
                #inputs.mac-app-util.darwinModules.default
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
