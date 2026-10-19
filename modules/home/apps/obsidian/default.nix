{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.apps.obsidian;
in {
  options.mine.home-manager.apps.obsidian = {
    enable = lib.mkEnableOption "Enable obsidian";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.obsidian = {
        enable = true;
        package = pkgs.unstable.obsidian;
      };
    };
  };
}
