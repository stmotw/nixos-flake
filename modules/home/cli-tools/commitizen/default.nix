{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.commitizen;
in {
  options.mine.home-manager.cli-tools.commitizen = {
    enable = lib.mkEnableOption "Enable commitizen";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.commitizen
      ];
    };
  };
}
