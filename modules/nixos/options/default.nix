{ lib, self, ... }:
{
  options.noex = {
    hardware = {
      isLaptop = lib.mkEnableOption "Laptop-spezifische Features wie TLP und Backlight";
      hasNvidia = lib.mkEnableOption "Nvidia Treiber und Optimierungen";
    };
    vpn = {
      enable = lib.mkEnableOption "WireGuard home VPN";
      address = lib.mkOption {
        type = lib.types.str;
      };
    };
    desktop = {
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = "${self}/assets/background/wallpaper001.png";
      };
      fastfetchLogo = lib.mkOption {
        type = lib.types.path;
        default = "${self}/assets/fastfetch/nixos_logo_1.webp";
      };
    };
  };
}
