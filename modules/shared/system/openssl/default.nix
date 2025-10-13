{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.openssl;
in {
  options.mine.system.openssl = {
    enable = lib.mkEnableOption "Enable openssl";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssl
      openssl.dev
    ];
  };
}
