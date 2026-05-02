{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    luaLoader.enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          telescope.enabled = true;
          which_key = true;
          notify = true;
          noice = true;
        };
      };
    };

    colorscheme = "catppuccin-mocha";

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;

      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;

      hlsearch = false;
      incsearch = true;
      ignorecase = true;
      smartcase = true;

      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;

      updatetime = 50;
      timeoutlen = 300;

      mouse = "a";
      clipboard = "unnamedplus";

      splitright = true;
      splitbelow = true;

      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];
    };

    plugins = {
      web-devicons.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "nix"
            "lua"
            "vim"
            "vimdoc"
            "bash"
            "rust"
            "go"
            "python"
            "javascript"
            "typescript"
            "tsx"
            "html"
            "css"
            "json"
            "yaml"
            "toml"
            "markdown"
            "markdown_inline"
            "regex"
            "dockerfile"
          ];
        };
      };
      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [ "nixfmt" ];
              nix.flake.autoArchive = true;
            };
          };

          lua_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          gopls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          bashls.enable = true;
          marksman.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
        };

        keymaps = {
          silent = true;
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "gr" = "references";
            "gt" = "type_definition";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
            "<leader>f" = "format";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>dl" = "open_float";
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          snippet.expand = ''
            function(args) require('luasnip').lsp_expand(args.body) end
          '';
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
      luasnip.enable = true;
      friendly-snippets.enable = true;

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            lua = [ "stylua" ];
            python = [ "black" ];
            rust = [ "rustfmt" ];
            go = [ "gofmt" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            sh = [ "shfmt" ];
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 1000;
          };
        };
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fr" = "oldfiles";
          "<leader>fs" = "lsp_document_symbols";
          "<leader>fd" = "diagnostics";
          "<leader>/" = "current_buffer_fuzzy_find";
        };
      };

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          view_options.show_hidden = true;
          delete_to_trash = true;
        };
      };

      lualine = {
        enable = true;
        settings.options.theme = "auto";
      };
      bufferline.enable = true;
      which-key.enable = true;
      noice.enable = true;
      notify.enable = true;
      indent-blankline.enable = true;

      alpha = {
        enable = true;
        theme = "dashboard";
      };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };
      nvim-autopairs.enable = true;
      comment.enable = true;
      nvim-surround.enable = true;
      todo-comments.enable = true;
      render-markdown.enable = true;
    };

    extraPackages = with pkgs; [
      nixfmt
      nil

      stylua

      ripgrep
      fd

      prettier
      black
      shfmt
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>nh";
        action = "<cmd>nohl<CR>";
        options.desc = "Clear search";
      }

      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<CR>";
        options.desc = "Close buffer";
      }

      {
        mode = "n";
        key = "<leader>sv";
        action = "<C-w>v";
        options.desc = "Split vertical";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<C-w>s";
        options.desc = "Split horizontal";
      }
      {
        mode = "n";
        key = "<leader>sx";
        action = "<cmd>close<CR>";
        options.desc = "Close split";
      }

      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.silent = true;
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.silent = true;
      }

      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
        options.desc = "File explorer";
      }
    ];
  };
}
