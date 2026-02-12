{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    
    extraConfig = {
      display-drun = ">";
      drun-display-format = "{name}";
      show-icons = true;
    };
    
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#f1dfda";
        font = "Fira Sans Semibold 11";
      };

      "window" = {
        background-color = mkLiteral "rgba(26, 17, 15, 0.4)";
        border = mkLiteral "2px";
        border-color = mkLiteral "rgba(255, 255, 255, 1.0)";
        border-radius = mkLiteral "12px";
        width = mkLiteral "40%";
        padding = mkLiteral "20px";
      };

      "mainbox" = {
        children = map mkLiteral [ "inputbar" "listview" ];
      };

      "inputbar" = {
        background-color = mkLiteral "rgba(39, 29, 27, 0.3)";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "10px";
        margin = mkLiteral "0px 0px 10px 0px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      "listview" = {
        lines = 8;
        columns = 1;
        fixed-height = true;
      };

      "element" = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
      };

      "element selected" = {
        background-color = mkLiteral "rgba(39, 29, 27, 0.9)";
        text-color = mkLiteral "#ffb59f";
      };

      "element-icon" = {
        size = mkLiteral "24px";
        margin = mkLiteral "0px 10px 0px 0px";
      };
    };
  };
}