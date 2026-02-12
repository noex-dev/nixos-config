{ pkgs, ... }:

let
  colors = {
    bar_bg = "rgba(0, 0, 0, 0)";
    module_bg = "rgba(39, 29, 27, 0.8)";
    border = "rgba(160, 140, 135, 0.2)";
    primary = "#ffb59f";
    text = "#f1dfda";
    text_dim = "#d8c2bc";
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";

    settings = [{
      layer = "top";
      position = "top";
      height = 38;
      margin-top = 4;
      margin-left = 8;
      margin-right = 8;
      spacing = 0;

      modules-left = [ 
        "custom/appmenu" 
        "hyprland/workspaces" 
      ];

      "custom/appmenu" = {
        format = "";
        on-click = "rofi -show drun";
      };

      "hyprland/workspaces" = {
        on-scroll-up = "hyprctl dispatch workspace r-1";
        on-scroll-down = "hyprctl dispatch workspace r+1";
        format = "{icon}";
        on-click = "activate";
      };

      modules-center = [ 
        "hyprland/window" 
      ];
      
      "hyprland/window" = {
        max-length = 40;
        separate-outputs = true;
      };

      modules-right = [ 
        "pulseaudio"
        "network"
        "battery"
        "tray"
        "custom/exit"
        "clock"
      ];

      "network" = {
        "format-wifi" = ""; 
        "format-ethernet" = "";
        "format-disconnected" = "⚠";
        "tooltip-format" = "{essid} ({signalStrength}%)";
        "on-click" = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      "battery" = {
        "states" = { "warning" = 30; "critical" = 15; };
        "format" = "{icon} {capacity}%";
        "format-charging" = " {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-icons" = ["" "" "" "" ""];
      };

      "tray" = {
        "icon-size" = 18;
        "spacing" = 10;
      };

      "custom/exit" = {
        "format" = "";
        "on-click" = "${pkgs.wlogout}/bin/wlogout -b 2";
        "tooltip" = false;
      };

      "clock" = {
        "interval" = 1;
        "format" = "{:%H:%M:%S - %d.%m.%y}";
        "tooltip-format" = "<tt><small>{calendar}</small></tt>";
      };    
    }];

    style = ''
      * {
        font-family: "Fira Sans Semibold", "Font Awesome 6 Free";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: ${colors.bar_bg};
      }

      #workspaces,
      #window,
      #pulseaudio,
      #network,
      #battery,
      #clock,
      #tray,
      #custom-appmenu,
      #custom-exit {
        background-color: ${colors.module_bg};
        color: ${colors.text};
        border-radius: 12px;
        border: 1px solid ${colors.border};
        margin: 4px 4px;
        padding: 0px 12px;
        transition: all 0.3s ease;
      }

      #workspaces {
        padding: 0px 4px;
      }

      #workspaces button {
        color: ${colors.text_dim};
        padding: 0px 8px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        color: ${colors.primary};
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
      }

      #window {
        background-color: transparent;
        border: none;
      }

      #custom-appmenu:hover,
      #custom-exit:hover,
      #pulseaudio:hover {
        background-color: ${colors.primary};
        color: ${colors.bar_bg};
      }

      #clock {
        font-weight: bold;
      }
    '';
  };
}