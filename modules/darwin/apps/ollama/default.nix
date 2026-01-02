{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.ollama;
in {
  options.mine.apps.ollama = {
    enable = lib.mkEnableOption "Install ollama";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["ollama-app"];
  };
}
