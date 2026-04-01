{ lib, self, ... }:
{
  options.noex = {
    hardware = {
      isLaptop = lib.mkEnableOption "Laptop-spezifische Features wie TLP und Backlight";
      hasNvidia = lib.mkEnableOption "Nvidia Treiber und Optimierungen";
    };
    desktop = {
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = "${self}assets/background/wallpaper001.png";
      };
    };
  };
}
