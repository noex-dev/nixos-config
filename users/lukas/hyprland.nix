{ config, pkgs, ... }:

let
  videoWallpaper = ./assets/background/animated_dogs.mp4;
  fallbackImage = ./assets/background/animated_dogs.jpg;

  startWallpaper = pkgs.writeShellScript "start-wallpaper" ''
    pkill mpvpaper
    pkill swaybg

    ${pkgs.swaybg}/bin/swaybg -i ${fallbackImage} -m fill &

    sleep 0.5

    ${pkgs.mpvpaper}/bin/mpvpaper -o "--loop --no-audio --panscan=1 --hwdec=auto" "*" ${videoWallpaper}
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      exec-once = [
        "${startWallpaper}"
      ];

      monitor = [
        ",preferred,auto,1"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(595959aa)";
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
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "CONTROL_$mod, Return, exec, rofi -show drun"
        "$mod, Q, killactive,"
        "$mod SHIFT, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"
        "$mod, P, pseudo," 
        "$mod, J, togglesplit," 
        "$mod, L, exec, hyprlock"
        
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod CONTROL SHIFT, B, exec, kitty --title 'NixOS Rebuild' sh -c 'sudo nixos-rebuild switch --flake /home/lukas/nixos-config#$(hostname) && notify-send \"System updated!\" || notify-send \"Rebuild failed!\"'"
      ];
    };
  };
}