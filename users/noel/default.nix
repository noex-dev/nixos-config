{ pkgs, ... }:

let
  homeDir = "/home/noel";
in
{
  imports = [
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/hyprlock
    ../../modules/home-manager/hyprpanel
    ../../modules/home-manager/programs
    ../../modules/home-manager/firefox
    ../../modules/home-manager/rofi
    ../../modules/home-manager/shell
    ../../modules/home-manager/theme
  ];

  home.username = "noel";
  home.homeDirectory = homeDir;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;

    documents = "${homeDir}/Data";
    download = "${homeDir}/Temp";
    desktop = "${homeDir}/Projects";

    music = "${homeDir}/Media/Music";
    pictures = "${homeDir}/Media/Pictures";
    videos = "${homeDir}/Media/Videos";

    templates = null;
    publicShare = null;

    extraConfig = {
      games = "${homeDir}/Games";
      vms = "${homeDir}/VMs";
    };
  };

  home.stateVersion = "25.11";
}
