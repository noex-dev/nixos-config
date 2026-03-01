{ pkgs, ... }:

{
  imports = [
    ./nix-settings.nix
    ./locale.nix
    ./users.nix
    ./desktop.nix
    ./networking.nix
    ./programs.nix
    ./sops.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "25.11";
}
