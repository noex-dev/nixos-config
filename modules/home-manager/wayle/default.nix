{
  pkgs,
  ...
}:

{
  services.wayle = {
    enable = true;

    settings = {
      styling = {
        theme-provider = "wayle";
        scale = 1.0;
        theming-monitor = "*";

        palette = {
          bg = "#11111b";
          surface = "#181825";
          elevated = "#1e1e2e";
          fg = "#cdd6f4";
          fg-muted = "#bac2de";
          primary = "#b4befe";
          red = "#f38ba8";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          blue = "#74c7ec";
        };

        font = {
          family = "Fira Sans Semibold";
          size = 13;
        };

        rounding = "lg";
      };

      bar = {
        location = "top";
        scale = 0.85;
        bg = "transparent";
        button-variant = "basic";
        button-rounding = "full";

        layout = [
          {
            monitor = "*";
            left = [
              "dashboard"
              "hyprland-workspaces"
              "media"
              "notifications"
            ];
            center = [ "window-title" ];
            right = [
              "volume"
              "bluetooth"
              "network"
              "battery"
              "clock"
            ];
          }
        ];
      };

      modules.clock.format = "%H:%M:%S - %d.%m.%Y";
      modules."window-title".max-length = 40;
      modules.notification.popup-duration = 3000;

      wallpaper.engine-enabled = false;
    };
  };

  services.swaync.enable = false;

  home.packages = with pkgs; [
    hypridle
    fira-sans
  ];
}
