{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.pi;
in {
  options.mine.home-manager.cli-tools.pi = {
    enable = lib.mkEnableOption "Enable pi coding agent";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.pi-coding-agent
      ];
    };
  };
}
