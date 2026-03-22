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
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      nix-flatpak,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/${hostname}/default.nix
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
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
