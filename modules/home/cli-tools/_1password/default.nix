{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools._1password;
in {
  options.mine.home-manager.cli-tools._1password = {
    enable = lib.mkEnableOption "1Password CLI";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = [
        pkgs.unstable._1password-cli
      ];
    };
  };
}
