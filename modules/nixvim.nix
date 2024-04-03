{config, pkgs, user, ...}:
{
  #xdg.configFile."nvim.snippets".source = config.lib.file.mkOutOfStoreSymlink "/home/bedw/Documents/nixos/flake/modules/neovim";

  programs.nixvim = {
    enable = true;
    colorscheme = "molokai";
    viAlias = true;

    #luaLoader.enable = true;
    defaultEditor = true;
    globals.mapleader = " ";
    #globals.maplocalleader = " ";
    globals.loaded_python_provider = false;
    #globals.python3_host_prog = "${pkgs.python3.withPackages (ps: with ps; [ pynvim ] )}/bin/python3";
    globals.python3_host_prog = "/run/current-system/sw/bin/python3";

    path = "nvim";
    #clipboard = {
    #  register = "unnamedplus";
    #};

    options = {
      mouse = "i";
      encoding = "utf-8";
      number = true;
      relativenumber = true;

      scrolloff = 6;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      smartindent = true;
      autoindent = true;

      swapfile = false;
      backup = false;
      
      undofile = true; 
        
      smartcase = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      signcolumn = "yes";
      updatetime = 50;
      fileformat = "unix";

      showcmd= false;

      completeopt = ["menu" "menuone" "noselect"];
    };

    keymaps = [
      # Shift Tab -> Unindent
      { mode= "i"; key = "<S-Tab>"; action = "<C-\\><C-N><<<C-\\><C-N>^i"; options.silent = true; }
      # Move selected lines
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }

      # Fix cursor position
      { mode = "n"; key = "J"; action = "mzJ`z"; }
      { mode = "n"; key = "<PageDown>"; action = "<C-d>zz"; }
      { mode = "n"; key = "<PageUp>"; action = "<C-u>zz"; }
      { mode = "n"; key = "n"; action = "nzzzv"; }
      { mode = "n"; key = "N"; action = "Nzzzv"; }
  
      # Fix paste
      { mode = "v"; key = "<leader>p"; action = ''[["_dP]]''; lua = true;}
      
      #'
      { mode = "n"; key = "H" ; action = "$"; }
      { mode = "n"; key = "L" ; action = "^"; }

      # Resize with arrows
      { mode = "n"; key = "<C-Up>"; action = ":resize -2<CR>"; }
      { mode = "n"; key = "<C-Down>"; action = ":resize +2<CR>"; }
      { mode = "n"; key = "<C-Left>"; action = ":vertical resize +2<CR>"; }
      { mode = "n"; key = "<C-Right>"; action = ":vertical resize -2<CR>"; }

      # Fix indenting in VISUAL mode
      { mode = "v"; key = ">"; action = ">gv"; }
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = "<TAB>"; action = ">gv"; }
      { mode = "v"; key = "<S-TAB>"; action = "<gv"; }
      { mode = "v"; key = "="; action = "=gv"; }

      # spell
      { mode = "i"; key = "<C-l>"; action = "<c-g>u<Esc>[s1z=`]a<c-g>u"; }

      # fix "x" key
      { mode = "v"; key = "x"; action = "d"; }
    ];

    autoCmd = [
      {
        event = "FileType";
        pattern = [ "tex" "latex" "markdown" ];
        command = "setlocal spell spelllang=en,es";
      }
      {
        event = "FileType";
        pattern = [ "tex" "latex" ];
        command = "set conceallevel=2";
      }
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2";
      }
    ];

    plugins = {
      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";

          quickfix_enabled = true;
          quickfix_open_on_warning = false;
          quickfix_ignore_filters = [
            "Underfull"
            "Overfull"
            "specifier changed to"
            "Token not allowed in a PDF string"
          ];
          compiler_latexmk.options = [
            "-shell-escape"
            "-verbose"
            "-file-line-error"
            "-synctex=1"
            "-interaction=nonstopmode"
          ];

        };
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
        disabledLanguages = [ "latex" "tex" ];
        folding = false;
        indent = true;
      };

      hmts.enable = false;
      telescope = {
        enable = true;
        defaults.layout_config.horizontal.preview_cutoff = 0; 
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>b" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fd" = "diagnostics";

          "<C-p>" = "git_files";
          "<leader>p" = "oldfiles";
          "<C-f>" = "live_grep";
        };

        keymapsSilent = true;

        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];
          set_env.COLORTERM = "truecolor";
        };
      };

      luasnip = {
        enable = true;
        extraConfig = {
          enable_autosnippets = true;
          updateevents = "TextChanged,TextChangedI";
        };
        fromLua = [ 
          {
            paths.__raw =  "\"/home/bedw/Documents/nixos/flake/modules/neovim/snippets\"";
          } 
        ];
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };

          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 10;
          };
          formatting.fields = ["kind" "abbr" "menu"];

        sources = [
          { name = "nvim_lsp";}
          { name = "vimtex"; }
          { name = "emoji";}
          {
            name = "buffer"; # text within current buffer
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          { name = "path"; keywordLength = 3; }
          { name = "luasnip"; keywordLength = 3; }
        ];
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {border = "rounded";};
        };
        };
      };
      
      harpoon = {
        enable = true;
        keymapsSilent = true;
        keymaps = {
          addFile = "<leader>a";
          toggleQuickMenu = "<C-e>";
          navFile = {
            "1" = "<C-1>";
            "2" = "<C-2>";
            "3" = "<C-3>";
            "4" = "<C-4>";
          };
        };
      };
      
      lsp = {
        enable = true;
        servers = {
          html.enable = true;
          jsonls.enable = true;
          julials.enable = true;
          marksman.enable = true;
          nixd.enable = true;
          clangd.enable = true;
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                autopep8.enabled = false;
                black.enabled = false;
                flake8.enabled = false;
                mccabe.enabled = false;
                memestra.enabled = false;
                pycodestyle.enabled = false;
                pydocstyle.enabled = false;
                isort.enabled = true;
                pyflakes.enabled = false;
                pylint.enabled = false;
                pylsp_mypy.enabled = true;
                yapf.enabled = false;
              };
            };
          };
          lua-ls.enable = true;

          bashls.enable = true;
          taplo.enable = true;
          texlab.enable = true;
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Goto Definition";
            };
            gr = {
              action = "references";
              desc = "Goto References";
            };
            gD = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            gI = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            gT = {
              action = "type_definition";
              desc = "Type Definition";
            };
            K = {
              action = "hover";
              desc = "Hover";
            };
            "<leader>cw" = {
              action = "workspace_symbol";
              desc = "Workspace Symbol";
            };
            "<leader>cr" = {
              action = "rename";
              desc = "Rename";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Action";
            };
            "<C-h>" = {
              action = "signature_help";
              desc = "Signature Help";
            };
          };
        };
      };

      # oil.enable;
      cmp-latex-symbols.enable = true;
      cmp-nvim-lsp = {enable = true;}; # lsp
      cmp-buffer = {enable = true;};
      cmp-path = {enable = true;}; # file system paths
      cmp_luasnip = {enable = true;}; # snippets

      vim-slime.enable = true;
      undotree.enable = true;
      nix.enable = true;
      surround.enable = true;

      comment.enable = true;
      leap.enable = true;
      julia-cell.enable = true;
      gitsigns.enable = true;
    };



    extraPlugins = with pkgs.vimPlugins; [
      molokai
      telescope-lsp-handlers-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "snippet-converter.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "smjonas";
          repo = "snippet-converter.nvim";
          rev= "d7e783618f02541641980ebd823e439bdef64a4f";
          hash = "sha256-l6d+0VPpGozfl5eoQBwuqwKzca61TzF/SH12EPw0Ths=";
        };
      })
    ];
    extraConfigLua = ''
      local cmp = require("cmp")

      cmp.setup.filetype('julia', {
        sources = cmp.config.sources({
          {name = 'cmp-latex-symbols'},
        })
      })

      require('telescope').load_extension('lsp_handlers')

    '';

    extraConfigVim = ''
      hi MatchParen gui=bold guibg=NONE guifg=orange
      hi SpellBad cterm=bold,underline gui=underline,bold guibg=NONE guifg=#FF5733
      hi Normal guibg=black
      hi LineNr guibg=black
      hi SignColumn guibg=black
      hi clear Conceal
    '';
  };
}
