{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.pkgconfig;
in {
  options.mine.system.pkgconfig = {
    enable = lib.mkEnableOption "Enable pkg-config";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pkg-config
    ];
  };
}
