{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.pgadmin;
in {
  options.mine.apps.pgadmin = {
    enable = lib.mkEnableOption "Enable pgadmin";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pgadmin4-desktopmode
    ];
  };
}
