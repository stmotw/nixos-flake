{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.nodejs;
in {
  options.mine.home-manager.cli-tools.nodejs = {
    enable = lib.mkEnableOption "Enable nodejs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        nodejs
      ];
    };
  };
}
