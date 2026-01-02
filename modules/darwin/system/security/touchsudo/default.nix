{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.security.touchsudo;
in {
  options.mine.system.security.touchsudo = {
    enable = lib.mkEnableOption "Enable TouchID for sudo authentication";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.sudo_local.touchIdAuth = true;
    environment.systemPackages = [
      pkgs.pam-reattach
    ];
  };
}
