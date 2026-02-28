{ pkgs, ... }:

{
  programs.zsh.enable = true;
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      show_cpu_temperature = 1;
      show_program_path = 0;
    };
  };
  
  environment.systemPackages = with pkgs; [
    git-lfs
    curl
    wget
    unzip
    zip
  ];
}
