{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      LANG = "en_GB.UTF-8";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = ''
        $directory$git_branch$git_status
        $character
      '';

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      git_branch = {
        format = "on [$symbol$branch]($style) ";
        symbol = " ";
        style = "bold magenta";
      };

      git_status = {
        format = "([\\[$all_status$next_status\\]]($style) )";
        style = "bold red";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol]($style) ";
        style = "bold blue";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd j"
    ];
  };

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];
}
