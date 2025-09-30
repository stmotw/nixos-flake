{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.cruft;
in {
  options.mine.home-manager.cli-tools.cruft = {
    enable = lib.mkEnableOption "Enable cruft";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.cruft
      ];
    };
  };
}
