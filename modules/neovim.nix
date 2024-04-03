{config, pkgs, nixvim, ...}:

nixvim = {
  enable = true;
  colorscheme = "molokai";
  viAlias = true;
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
    # undotree 

    hlsearch = false;
    incsearch = true;

    termguicolors = true;

    signcolumn = "yes";

    updatetime = 50;

    fileformat = "unix";
  };

  extraPlugins = with pkgs.vimPlugins; [
    molokai
  ];
};
