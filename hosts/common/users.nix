{ pkgs, ... }:

{
  users.users.lukas = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "kvm"
    ];
    shell = pkgs.zsh;
  };
}
