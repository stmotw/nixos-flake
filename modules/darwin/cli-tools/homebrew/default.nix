{
  config,
  lib,
  ...
}: let
  cfg = config.mine.cli-tools.homebrew;
in {
  options.mine.cli-tools.homebrew = {
    enable = lib.mkEnableOption "Enable homebrew";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPath = [
      "/opt/homebrew/bin"
    ];

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
        extraEnv = {
          HOMEBREW_NO_UPDATE_REPORT_NEW = "1";
          HOMEBREW_NO_ENV_HINTS = "1";
        };
      };
    };
  };
}
