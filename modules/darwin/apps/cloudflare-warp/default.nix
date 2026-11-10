{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.cloudflare-warp;
in {
  options.mine.apps.cloudflare-warp = {
    enable = lib.mkEnableOption "Install cloudflare-warp";
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = ["cloudflare-warp"];
  };
}
