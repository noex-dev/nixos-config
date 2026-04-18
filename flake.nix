{
  description = "nixos-config by noex; see https://github.com/noex/nixos-config.git";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      disko,
      impermanence,
      home-manager,
      sops-nix,
      firefox-addons,
      zen-browser,
      mac-style-plymouth,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs self;
          };

          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/${hostname}/default.nix
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                backupFileExtension = "hm-backup";
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs self; };
                users.noel = import ./users/noel/default.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        pc = mkSystem "pc";
        p16s = mkSystem "p16s";
      };

      formatter.${system} = pkgs.nixfmt-tree;

      apps.${system} = {
        setup-secureboot = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "setup-secureboot";
              runtimeInputs = [
                pkgs.sbctl
                pkgs.systemd
                pkgs.util-linux
                pkgs.coreutils
              ];
              text = builtins.readFile ./scripts/setup-secureboot.sh;
            }
          }/bin/setup-secureboot";
        };

        install-system = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "install-system";
              runtimeInputs = [
                pkgs.git
                pkgs.disko
              ];
              text = builtins.readFile ./scripts/install-system.sh;
            }
          }/bin/install-system";
        };
      };
    };
}
