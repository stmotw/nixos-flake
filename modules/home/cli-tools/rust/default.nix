{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.rust;
in {
  options.mine.home-manager.cli-tools.rust = {
    enable = lib.mkEnableOption "Enable rust";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        rust-bin.stable.latest.default
      ];
    };
  };
}
