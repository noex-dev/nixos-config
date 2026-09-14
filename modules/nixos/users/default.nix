{ pkgs, config, ... }:

{
  users.users.noel = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "kvm"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.noel_password.path;
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
