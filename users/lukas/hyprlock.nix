{ config, pkgs, ... }:

let
  screenshot = ./assets/background/animated_dogs.jpg;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = [{
        path = "${screenshot}";
        blur_passes = 2;
        color = "rgba(26, 17, 15, 1.0)";
      }];

      input-field = [{
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 1.0)";
        inner_color = "rgba(39, 29, 27, 0.4)";
        font_color = "rgb(241, 223, 218)";
        fade_on_empty = false;
        placeholder_text = "<i>Password...</i>";
        hide_input = false;
        position = "0, -20";
        halign = "center";
        valign = "center";
      }];

      label = [{
        text = "$TIME";
        color = "rgb(255, 181, 159)";
        font_size = 64;
        font_family = "Fira Sans Semibold";
        position = "0, 80";
        halign = "center";
        valign = "center";
      }];
    };
  };
}