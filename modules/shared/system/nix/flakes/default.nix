{
  config,
  lib,
  ...
}: let
  cfg = config.mine.system.nix.flakes;
in {
  options.mine.system.nix.flakes = {
    enable = lib.mkEnableOption "Enable nix flakes";
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
