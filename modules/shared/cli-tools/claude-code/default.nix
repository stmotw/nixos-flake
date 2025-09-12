{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mine.cli-tools.claude-code;
in {
  options.mine.cli-tools.claude-code = {
    enable = lib.mkEnableOption "claude code client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.claude-code
    ];
  };
}
