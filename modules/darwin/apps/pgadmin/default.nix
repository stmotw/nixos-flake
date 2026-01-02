{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.pgadmin;
in {
  options.mine.apps.pgadmin = {
    enable = lib.mkEnableOption "Install pgadmin";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["pgadmin4"];
  };
}
