{ config, pkgs, ... }:

{
  sops.secrets.nix_attic_netrc = { };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://attic.airlab.at/urc"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "urc:bf7dM5QSYGQJWyTEj4mKUcW13t6u2ArDISMViTr1/d8="
      ];

      netrc-file = config.sops.secrets.nix_attic_netrc.path;

      connect-timeout = 5;
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  boot.loader.systemd-boot.configurationLimit = 30;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
