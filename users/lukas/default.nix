{ pkgs, ... }:

{
  imports = [
    ./programs.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./theme.nix
    ./waybar.nix
    ./rofi.nix
    ./wlogout.nix
    ./shell.nix
  ];

  home.username = "lukas";
  home.homeDirectory = "/home/lukas";
  home.stateVersion = "25.11";
}