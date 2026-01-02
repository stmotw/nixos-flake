{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.uv;
in {
  options.mine.home-manager.cli-tools.uv = {
    enable = lib.mkEnableOption "Enable uv";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.uv
      ];

      home.sessionVariables = {
        UV_PREVIEW_FEATURES = "native-auth";
      };
    };
  };
}
