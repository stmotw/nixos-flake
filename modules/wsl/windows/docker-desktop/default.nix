{
  lib,
  config,
  ...
}: let
  cfg = config.mine.windows.docker-desktop;
in {
  options.mine.windows.docker-desktop = {
    enable = lib.mkEnableOption "Enable integration with docker desktop on Windows";
  };

  config = lib.mkIf cfg.enable {
    wsl.docker-desktop.enable = true;
  };
}
