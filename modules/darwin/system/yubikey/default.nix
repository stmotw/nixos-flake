{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.yubikey;
in {
  options.mine.system.yubikey = {
    enable = lib.mkEnableOption "Enable yubikey FIDO support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libfido2
      openssh
    ];
  };
}
