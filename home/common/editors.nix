{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
