{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}:

let
  wallpaperSource = "${../../../assets/background/wallpaper001.png}";
in
{
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme.matugen = true;
      theme.matugen_settings = {
        wallpaper = wallpaperSource;
        scheme = "scheme-tonal-spot";
        type = "image";
      };

      wallpaper.image = wallpaperSource;

      bar = {
        layouts."0" = {
          left = [
            "dashboard"
            "workspaces"
            "notifications"
            "media"
          ];
          middle = [ "windowtitle" ];
          right = [
            "volume"
            "bluetooth"
            "network"
            "battery"
            "clock"
          ];
        };

        launcher.icon = "";

        windowtitle = {
          max_length = 40;
          show_title = true;
          truncate_title = true;
          title_placeholder = false;
          icon = false;
        };

        workspaces = {
          workspaces = 9;
          show_icons = false;
          show_numbered = true;
        };

        clock.format = "%H:%M:%S - %d.%m.%Y";
      };

      menus.clock = {
        weather.enabled = false;
      };

      menus.dashboard = {
        user.name = "noel";
        shortcuts.enabled = false;
        directories.enabled = false;
        stats.enabled = true;
        weather.enabled = true;
        weather.unit = "metric";
        weather.location = "Vienna";
      };

      system.battery.device = "BAT0";

      theme = {
        font = {
          name = "Fira Sans Semibold";
          size = "13px";
        };

        bar = {
          transparent = true;
          buttons = {
            opacity = 80;
            radius = "12px";
          };
        };
      };
    };
  };

  services.swaync.enable = false;

  home.packages = with pkgs; [
    hypridle
    matugen
  ];
}
