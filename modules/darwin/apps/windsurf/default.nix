{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.windsurf;
in {
  options.mine.apps.windsurf = {
    enable = lib.mkEnableOption "Windsurf IDE";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["windsurf"];
  };
}
