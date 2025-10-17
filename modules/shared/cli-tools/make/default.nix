{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.make;
in {
  options.mine.cli-tools.make = {
    enable = lib.mkEnableOption "Enable make";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnumake
    ];
  };
}
