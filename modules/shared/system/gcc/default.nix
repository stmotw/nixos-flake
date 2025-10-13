{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.gcc;
in {
  options.mine.system.gcc = {
    enable = lib.mkEnableOption "Enable gcc";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
    ];
  };
}
