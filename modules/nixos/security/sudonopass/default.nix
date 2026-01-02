{
  config,
  lib,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.system.security.sudonopass;
in {
  options.mine.system.security.sudonopass = {
    enable = lib.mkEnableOption "Enable passwordless sudo";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraRules = [
      {
        users = ["${user.username}"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
