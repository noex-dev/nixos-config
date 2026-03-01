{ pkgs, ... }:

{
  imports = [
    ./nix-settings.nix
    ./locale.nix
    ./users.nix
    ./desktop.nix
    ./networking.nix
    ./audio.nix
    ./programs.nix
    ./sops.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "25.11";
}
