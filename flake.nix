{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "flake-utils";
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    attic,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage = home-manager.defaultPackage.${system};
    })
    // rec {
      mkSystem = {
        name,
        arch ? "x86_64-linux",
        extraModules ? [],
        extraArgs ? {},
      }: let
        pkgs = import nixpkgs {
          system = arch;
          overlays = [self.overlays.pkgs attic.overlays.default];
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            [
              ./hosts/${name}/configuration.nix
              ./modules
            ]
            ++ extraModules;
          extraSpecialArgs = inputs // extraArgs;
        };

      homeConfigurations = {
        "malos" = mkSystem {name = "malos";};
      };
      overlays.pkgs = final: prev: {
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        system = system;
      };
    in {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cacert
          curl
          jq

          nix-output-monitor
        ];
      };
    });
}
