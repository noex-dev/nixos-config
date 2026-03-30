{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      tree = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
      htop = "btop";
      help = "tldr";

      g = "git";
      gst = "git status";
      ga = "git add";
      gc = "git commit -v";
      gp = "git push";

      nrs = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
      nf = "nix fmt";
      da = "direnv allow";

      kplay = "mpv --vo=tct --panscan=1.0";
    };

    initContent = ''
      ns() {
        nix shell "nixpkgs#$1" "''${@:2}"
      }
    '';

    sessionVariables = {
      LANG = "en_GB.UTF-8";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      share = true;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = ''
        $directory$git_branch$git_status$nix_shell
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

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
      };
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      vim_keys = true;
      update_ms = 1000;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always --style=numbers {}'"
    ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd j"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config = {
      global = {
        warn_timeout = "5s";
      };
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.symbols-only

    bat
    ripgrep
    fd
    tldr
  ];
}
