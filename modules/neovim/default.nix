{config, pkgs, user, lib,  ...}:
{
  inherit (config.lib.file) mkOutOfStoreSymlink;
  programs.neovim = {
    enable = true;
    viAlias = true;

    defaultEditor = true;
  };
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "./.";


}
