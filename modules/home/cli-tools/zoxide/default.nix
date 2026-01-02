{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.zoxide;
in {
  options.mine.home-manager.cli-tools.zoxide = {
    enable = lib.mkEnableOption "zoxide configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        zoxide
      ];

      programs.zoxide = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
      };

      programs.zsh.shellAliases = lib.mkIf config.mine.home-manager.system.shell.zsh.enable {
        cd = "z";
      };
    };
  };
}
