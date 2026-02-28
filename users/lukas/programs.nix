{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lukas Sanz";
        email = "lukassanz11@gmail.com";
      };
      gpg.format = "ssh";
      commit.gpgsign = true;
    };
    
    signing = {
      key = "/home/lukas/.ssh/id_git";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; 
    
    matchBlocks = {
      "github.com" = {
        identityFile = "/home/lukas/.ssh/id_git";
        identitiesOnly = true; 
      };

      "git.robo4you.at" = {
        identityFile = "/home/lukas/.ssh/id_git";
	identitiesOnly = true;
      };

      "*" = {
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa"
        ];
      };
    };
  };

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
