{
  lib,
  config,
  ...
}: let
  cfg = config.mine.apps.seventeenlands;
in {
  options.mine.apps.seventeenlands = {
    enable = lib.mkEnableOption "Install the 17Lands client";
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      taps = ["rconroy293/seventeenlands"];
      brews = [
        {
          name = "rconroy293/seventeenlands/seventeenlands";
          start_service = true;
        }
      ];
    };
  };
}
