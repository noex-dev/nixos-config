{
  config,
  pkgs,
  ...
}:

let
  wallpaperSource = "${../../../assets/background/wallpaper001.png}";
  monitors = [
    "DP-2"
    "DP-3"
  ];
in
{
  home.packages = with pkgs; [
    awww
    grim
    slurp
    wl-clipboard
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      config = {
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = "de";
          kb_variant = "";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          col = {
            active_border = "rgba(ffffffff)";
            inactive_border = "rgba(595959aa)";
          };
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 0.9;
          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
          shadow = {
            enabled = true;
            range = 15;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          preserve_split = true;
        };
      };
    };

    extraConfig = ''
      -- Curves and animations
      hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
      hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
      hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

      -- Startup
      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprlock")
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("awww-daemon & sleep 1 && awww img ${wallpaperSource}")
        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")
      end)

      -- Keybindings
      local mainMod = "SUPER"

      hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + CTRL + Return",      hl.dsp.exec_cmd("rofi -show drun"))
      hl.bind(mainMod .. " + Q",            hl.dsp.window.close())
      hl.bind(mainMod .. " + SHIFT + M",    hl.dsp.exit())
      hl.bind(mainMod .. " + SPACE",        hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())
      hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())
      hl.bind(mainMod .. " + J",            hl.dsp.layout("togglesplit"))
      hl.bind(mainMod .. " + L",            hl.dsp.exec_cmd("hyprlock"))
      hl.bind(mainMod .. " + SHIFT + S",    hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
      hl.bind(mainMod .. " + V",            hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

      -- Workspace bindings
      for i = 1, 9 do
        hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end
      hl.bind(mainMod .. " + 0",         hl.dsp.focus({ workspace = 10 }))
      hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

      -- Media / volume keys (locked + repeating)
      hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),    { locked = true, repeating = true })
      hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),    { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                        { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),                        { locked = true, repeating = true })

      -- Display and WLAN keys (locked)
      hl.bind("XF86Display", hl.dsp.exec_cmd("wdisplays"),                                                                                    { locked = true })
      hl.bind("XF86WLAN",    hl.dsp.exec_cmd("nmcli radio wifi $(nmcli radio wifi | grep -q 'enabled' && echo 'off' || echo 'on')"), { locked = true })
    '';
  };
}
