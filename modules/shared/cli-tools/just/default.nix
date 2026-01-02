{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.just;
in {
  options.mine.cli-tools.just = {
    enable = lib.mkEnableOption "Enable just, its like make but more straight forward";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      just
    ];
  };
}
