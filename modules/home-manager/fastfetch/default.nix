{ pkgs, osConfig, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile = {
    "fastfetch/config.jsonc".source = ./config.jsonc;
    "fastfetch/logo/nixos_logo_2.webp".source = osConfig.noex.desktop.fastfetchLogo;
  };
}
