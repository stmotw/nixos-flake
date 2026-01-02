{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mine.cli-tools.charm-freeze;
in {
  options.mine.cli-tools.charm-freeze = {
    enable = lib.mkEnableOption "Create images of your code";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      charm-freeze
    ];
  };
}
