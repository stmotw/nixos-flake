{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.bitwarden;
in {
  options.mine.apps.bitwarden = {
    enable = lib.mkEnableOption "Install bitwarden";
  };

  config = lib.mkIf cfg.enable {
    homebrew.masApps = {
      "Bitwarden" = 1352778147;
    };
  };
}
