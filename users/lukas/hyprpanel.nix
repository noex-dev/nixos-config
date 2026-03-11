{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}:

{
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        layouts."0" = {
          left = [
            "dashboard"
            "workspaces"
          ];
          middle = [ "windowtitle" ];
          right = [
            "volume"
            "bluetooth"
            "network"
            "battery"
            "notifications"
            "clock"
          ];
        };

        windowtitle = {
          max_length = 40;
          title_placeholder = false;
        };

        workspaces = {
          workspaces = 9;
          show_icons = false;
          show_numbered = true;
        };
      };

      menus.dashboard = {
        user.name = "Lukas";
        shortcuts.enabled = false;
        directories.enabled = false;
        stats.enabled = true;
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

  home.packages = with pkgs; [
    hyprpicker
    hyprsunset
    hypridle
    btop
    grimblast
  ];
}
