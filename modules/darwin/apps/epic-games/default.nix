{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.epic-games;
in {
  options.mine.apps.epic-games = {
    enable = lib.mkEnableOption "Install epic games launcher";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["epic-games"];
  };
}
