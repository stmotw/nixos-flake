{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.yubico-authenticator;
in {
  options.mine.apps.yubico-authenticator = {
    enable = lib.mkEnableOption "Install Yubico Authenticator";
  };

  config = lib.mkIf cfg.enable {
    homebrew.masApps = {
      "Yubico Authenticator" = 1497506650;
    };
  };
}
