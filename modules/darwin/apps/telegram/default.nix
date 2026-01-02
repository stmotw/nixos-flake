{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.telegram;
in {
  options.mine.apps.telegram = {
    enable = lib.mkEnableOption "Install telegram";
  };

  config = lib.mkIf cfg.enable {
    homebrew.masApps = {
      "Telegram" = 747648890;
    };
  };
}
