{ pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Restart";
        keybind = "r";
      }
    ];
    style = ''
      window {
        background-color: rgba(26, 17, 15, 0.4);
      }

      button {
        color: #ffffff;
        background-color: rgba(39, 29, 27, 0.3);
        border: 2px solid rgba(255, 255, 255, 1);
        border-radius: 10px;
        margin: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        transition: all 0.3s ease;
      }

      button label {
        margin-top: 175px;
        font-size: 1.2rem;
      }

      button:hover {
        background-color: rgba(39, 29, 27, 0.9);
        outline-style: none;
      }

      #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    '';
  };
}