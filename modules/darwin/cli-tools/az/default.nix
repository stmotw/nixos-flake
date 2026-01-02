{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.cli-tools.az;
in {
  options.mine.cli-tools.az = {
    enable = lib.mkEnableOption "Enable Azure CLI";
  };

  config = lib.mkIf cfg.enable {
    homebrew.brews = ["azure-cli"];
  };
}
