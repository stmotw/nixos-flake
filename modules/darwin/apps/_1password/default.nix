{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps._1password;
in {
  options.mine.apps._1password = {
    enable = lib.mkEnableOption "1Password desktop app";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["1password"];
  };
}
