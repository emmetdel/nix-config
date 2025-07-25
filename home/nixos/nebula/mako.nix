({
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
      background-color = "#2b303b";
      border-color = "#65737e";
      border-radius = 5;
      border-size = 2;
      text-color = "#c0c5ce";
      font = "JetBrains Mono 12";
      default-timeout = 5000;
      group-by = "summary";
    };
  };
})
