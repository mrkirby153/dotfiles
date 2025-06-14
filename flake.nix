{
  description = "Home manager configuration";

  nixConfig = {
    extra-trusted-public-keys = "mrkirby153-public:DxpgFWGtjTaSh6U/bt+Xr5qfj4gVbRjUzaePmA/ndwM=";
    extra-substituters = "https://cache.mrkirby153.com/mrkirby153-public";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    atuin = {
      url = "github:atuinsh/atuin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
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
    atuin,
    nix-darwin,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage = home-manager.packages.${system}.default;

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
        overlays = [my-nixpkgs.overlays.default attic.overlays.default atuin.overlays.default self.overlays.pkgs];
        pkgs = import nixpkgs {
          inherit overlays;
          system = arch;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit overlays;
          system = arch;
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

      darwinConfigurations = let
        specialArgs =
          inputs
          // {
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
              overlays = [my-nixpkgs.overlays.default self.overlays.pkgs attic.overlays.default atuin.overlays.default];
            };
          };
      in {
        "austin@Austins-MBP" = nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.austin = {
                imports = [
                  sops-nix.homeManagerModule
                  ./lib/modules/home-manager
                  ./home-manager
                  ./hosts/austins-mbp/configuration.nix
                ];
              };
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
          specialArgs = specialArgs;
        };
      };

      overlays.pkgs = final: prev: let
        # Workaround for https://github.com/zhaofengli/attic/issues/249 and https://github.com/zhaofengli/attic/issues/250
        atticPkg = final.callPackage "${inputs.attic}/package.nix" {nix = final.nixVersions.nix_2_24;};
      in
        import ./pkg {
          pkgs = prev;
        }
        // {
          attic = atticPkg;
          attic-server = (atticPkg.override {creates = ["attic-server"];}).overrideAttrs (oldAttrs: {
            meta = final.lib.recursiveUpdate (oldAttrs.meta or {}) {mainProgram = "atticd";};
          });
          attic-client = atticPkg.override {clientOnly = true;};
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
