{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Hyprland
    hyprlock
    
    # Waybar
    wlogout
    
    # Background
    swaybg
    mpvpaper

    # Other
    vscode
    btop
    firefox
    bitwarden-desktop
  ];
  
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = false;
      background_opacity = 0.7;
      window_padding_width = 10; 
    };
  };

  programs.rofi.enable = true;
  programs.home-manager.enable = true;
}
