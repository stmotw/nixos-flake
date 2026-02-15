{
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.claude-code;
in {
  options.mine.cli-tools.claude-code = {
    enable = lib.mkEnableOption "claude code client";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["claude-code"];
  };
}
