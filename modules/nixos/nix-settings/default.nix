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
        "https://attic.airlab.at/urc"
      ];

      trusted-public-keys = [
        "urc:bf7dM5QSYGQJWyTEj4mKUcW13t6u2ArDISMViTr1/d8="
      ];

      netrc-file = config.sops.secrets.nix_attic_netrc.path;

      connect-timeout = 5;
      auto-optimise-store = true;

      max-jobs = 4;
      cores = 4;
    };

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "35%";
    MemoryMax = "40%";
    MemorySwapMax = "2G";
  };

  boot.loader.systemd-boot.configurationLimit = 30;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
