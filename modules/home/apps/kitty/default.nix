{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.apps.kitty;
in {
  options.mine.home-manager.apps.kitty = {
    enable = lib.mkEnableOption "Enable kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        kitty
      ];

      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
      };
    };
  };
}
