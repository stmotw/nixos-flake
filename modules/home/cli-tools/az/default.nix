{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.az;
in {
  options.mine.home-manager.cli-tools.az = {
    enable = lib.mkEnableOption "Enable Azure CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.azure-cli
      ];
    };
  };
}
