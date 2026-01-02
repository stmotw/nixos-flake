{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.glab;
in {
  options.mine.cli-tools.glab = {
    enable = lib.mkEnableOption "Enable glab, the GitLab CLI tool";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      glab
    ];
  };
}
