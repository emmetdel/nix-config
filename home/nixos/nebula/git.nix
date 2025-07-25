({
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Emmet Delaney"; # Change this
    userEmail = "emmetdel@gmail.com"; # Change this
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
})
