{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mine.cli-tools.direnv;
in {
  options.mine.cli-tools.direnv = {
    enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      direnv
    ];
  };
}
