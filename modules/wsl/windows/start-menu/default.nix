{
  lib,
  config,
  ...
}: let
  cfg = config.mine.windows.start-menu;
in {
  options.mine.windows.start-menu = {
    enable = lib.mkEnableOption "Enable Windows start menu integration";
  };

  config = lib.mkIf cfg.enable {
    wsl.startMenuLaunchers = true;
  };
}
