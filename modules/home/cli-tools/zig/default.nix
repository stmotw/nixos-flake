{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.zig;
in {
  options.mine.home-manager.cli-tools.zig = {
    enable = lib.mkEnableOption "Enable zig";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.zig
      ];
    };
  };
}
