{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Emmet Delaney";
    userEmail = "emmet@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
