{
  description = "Home manager configuration";

  nixConfig = {
    extra-trusted-public-keys = "mrkirby153-public:DxpgFWGtjTaSh6U/bt+Xr5qfj4gVbRjUzaePmA/ndwM=";
    extra-substituters = "https://cache.mrkirby153.com/mrkirby153-public";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "flake-utils";
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    my-nixpkgs = {
      url = "github:mrkirby153/nix-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nvim = {
      url = "github:mrkirby153/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    atuin = {
      url = "github:atuinsh/atuin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-utils,
    attic,
    sops-nix,
    my-nixpkgs,
    my-nvim,
    atuin,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage = home-manager.defaultPackage.${system};

      packages = let
        pkgs = import nixpkgs {
          overlays = [my-nixpkgs.overlays.default];
          inherit system;
        };
      in
        import ./pkg {
          inherit pkgs;
        };
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
          overlays = [my-nixpkgs.overlays.default self.overlays.pkgs attic.overlays.default atuin.overlays.default];
        };
        pkgs-unstable = import nixpkgs-unstable {
          system = arch;
          overlays = [my-nixpkgs.overlays.default self.overlays.pkgs attic.overlays.default atuin.overlays.default];
        };
        ts = import ./hosts/ts.nix {
          inherit pkgs;
          inherit (pkgs) lib;
        };
        aus = import ./lib {
          inherit pkgs;
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            [
              sops-nix.homeManagerModule
              ./lib/modules/home-manager
              ./home-manager
              ./hosts/${name}/configuration.nix
            ]
            ++ extraModules;
          extraSpecialArgs =
            inputs
            // extraArgs
            // {
              inherit pkgs-unstable;
              inherit ts;
              aus.lib = aus;
            };
        };

      homeConfigurations = {
        "austin@malos" = mkSystem {name = "malos";};
        "austin@aus-box" = mkSystem {name = "aus-box";};
      };

      overlays.pkgs = final: prev:
        import ./pkg {
          pkgs = prev;
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
          sops

          nix-output-monitor
        ];
      };
    });
}
