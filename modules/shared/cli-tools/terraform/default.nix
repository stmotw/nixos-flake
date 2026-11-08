{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.terraform;
in {
  options.mine.cli-tools.terraform = {
    enable = lib.mkEnableOption "Enable terraform";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.terraform
    ];
  };
}
